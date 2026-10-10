ARG IMAGE
FROM ${IMAGE}
# bob: php runbox.php (bob adds <?php and the autoloader)
RUN echo '<?php require "/home/user01/vendor/autoload.php"; echo class_exists("Illuminate\\Support\\Collection") ? "hi" : "no laravel";' > runbox.php && test "$(php runbox.php)" = hi
