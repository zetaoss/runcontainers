ARG IMAGE
FROM ${IMAGE}
# bob: g++ runbox.cpp; ./a.out
RUN printf '#include <iostream>\nint main(){std::cout<<"hi";}\n' > runbox.cpp && g++ runbox.cpp && test "$(./a.out)" = hi
