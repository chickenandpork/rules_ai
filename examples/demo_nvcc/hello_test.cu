#include <stdio.h>
#include <iostream>
#include <cuda.h>

#define CUDA_CHECK(expr)                                                \
    do {                                                                  \
        cudaError_t err = (expr);                                           \
        if (err != cudaSuccess) {                                           \
            printf("CUDA Error Code  : %d\n     Error String: %s\n", \
              err, cudaGetErrorString(err));                            \
            exit(err);                                                        \
        }                                                                   \
    } while (0)

__global__ void kernel__cuda_hello(){
    printf("Hello World from GPU!\n");
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());
}

int main() {
    kernel__cuda_hello<<<1,1>>>(); 
    cudaDeviceSynchronize(); // Essential to see the print output
    return 0;
}
