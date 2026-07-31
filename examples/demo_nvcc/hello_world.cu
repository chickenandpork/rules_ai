#include <iostream>
#include <cuda.h>

__global__ void kernel__cuda_hello(){
    printf("Hello World from GPU!\n");
}

int main() {
    kernel__cuda_hello<<<1,1>>>(); 
    return 0;
}
