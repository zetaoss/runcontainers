ARG IMAGE
FROM ${IMAGE}
# bob: /bin/bash runbox.sh
RUN echo 'echo hi' > runbox.sh && test "$(/bin/bash runbox.sh)" = hi
