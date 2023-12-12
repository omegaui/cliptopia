#!/bin/bash

javac -d bin src/Injector.java
mv bin/Injector.class ../assets/scripts
rmdir bin