gulp = require 'gulp'
mocha = require 'gulp-mocha'

gulp.task 'tests', () ->
    gulp.src 'tests/**.coffee'
        .pipe mocha({reporter: 'spec'})
