ARG IMAGE
FROM ${IMAGE}
# bob: gcc runbox.c; ./a.out
RUN printf '#include <stdio.h>\nint main(){puts("hi");}\n' > runbox.c && gcc runbox.c && test "$(./a.out)" = hi
