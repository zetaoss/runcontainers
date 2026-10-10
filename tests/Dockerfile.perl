ARG IMAGE
FROM ${IMAGE}
# bob: perl runbox.pl
RUN echo 'use Math::NumberCruncher; print "hi";' > runbox.pl && test "$(perl runbox.pl)" = hi
