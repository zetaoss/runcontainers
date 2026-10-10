ARG IMAGE
FROM ${IMAGE}
# bob: lua runbox.lua
RUN echo 'print("hi")' > runbox.lua && test "$(lua runbox.lua)" = hi
