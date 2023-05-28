#!/bin/bash

if ! node -v >/dev/null 2>&1; then
  volta install node
fi
