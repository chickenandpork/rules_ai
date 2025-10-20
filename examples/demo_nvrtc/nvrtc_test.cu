#include <iostream>
#include <nvrtc.h>
#include <cuda.h>

#define CHECK_NVRTC(call) \
    do { \
        nvrtcResult _status = call; \
        if (_status != NVRTC_SUCCESS) { \
            std::cerr << "NVRTC error: " << nvrtcGetErrorString(_status) << std::endl; \
            exit(1); \
        } \
    } while (0)

#define CHECK_CUDA(call) \
    do { \
        CUresult _status = call; \
        if (_status != CUDA_SUCCESS) { \
            const char *errStr; \
            cuGetErrorString(_status, &errStr); \
            std::cerr << "CUDA error: " << (errStr ? errStr : "unknown") << std::endl; \
            exit(1); \
        } \
    } while (0)

int main() {
    const char *cuda_code = R"(
    extern "C" __global__
    void add_kernel(float *a, float *b, float *c, int n) {
        int idx = blockIdx.x * blockDim.x + threadIdx.x;
        if (idx < n) c[idx] = a[idx] + b[idx];
    })";

    nvrtcProgram prog;
    CHECK_NVRTC(nvrtcCreateProgram(&prog, cuda_code, "add_kernel.cu", 0, nullptr, nullptr));

    const char *opts[] = {"--gpu-architecture=compute_75"};
    nvrtcResult compile_res = nvrtcCompileProgram(prog, 1, opts);

    size_t logSize;
    nvrtcGetProgramLogSize(prog, &logSize);
    if (logSize > 1) {
        std::string log(logSize, '\0');
        nvrtcGetProgramLog(prog, &log[0]);
        std::cout << "NVRTC log:\n" << log << std::endl;
    }

    if (compile_res != NVRTC_SUCCESS) {
        std::cerr << "NVRTC failed to compile.\n";
        return 1;
    }

    size_t ptxSize;
    CHECK_NVRTC(nvrtcGetPTXSize(prog, &ptxSize));
    std::string ptx(ptxSize, '\0');
    CHECK_NVRTC(nvrtcGetPTX(prog, &ptx[0]));
    nvrtcDestroyProgram(&prog);

    CHECK_CUDA(cuInit(0));
    CUdevice device;
    CHECK_CUDA(cuDeviceGet(&device, 0));
    CUcontext context;
    CHECK_CUDA(cuCtxCreate(&context, 0, device));

    CUmodule module;
    CHECK_CUDA(cuModuleLoadData(&module, ptx.c_str()));
    CUfunction kernel;
    CHECK_CUDA(cuModuleGetFunction(&kernel, module, "add_kernel"));

    std::cout << "✅ NVRTC successfully compiled and linked CUDA code.\n";

    cuModuleUnload(module);
    cuCtxDestroy(context);
    return 0;
}