#include <iostream>
#include <cassert>
#include <cuda_runtime.h>

int main() {
    int deviceCount;
    switch (cudaGetDeviceCount(&deviceCount)) {
        case cudaSuccess:
            break;
        case cudaErrorNoDevice:
            std::cerr << "failed toget device count: no device" << std::endl;
            break;
        case cudaErrorInsufficientDriver:
            std::cerr << "failed toget device count: insufficient driver" << std::endl;
            break;
        default:
            break;
    }

    std::cout << "Number of devices: " << deviceCount << std::endl;

    assert(deviceCount > 0);

    for (int i = 0; i < deviceCount && deviceCount > 0; ++i) {
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, i);
        std::cout << "Device " << i << ": " << prop.name << " (Compute: " 
                  << prop.major << "." << prop.minor << ")" << std::endl;
    }
    return 0;
}
