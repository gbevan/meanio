meanio
======
A pre-built and initialised MEAN (http://mean.io) app server scaffolding.

$ docker run -d -p 80:3000 --name yourapp gbevan/meanio

Installs the meanio app under user mean (default pw is 'mean') in folder ~/appserver.

Mean.io scaffolding unit-tests are run as part of the docker image build, as a
filter to ensure released images pass all upstream unit-tests.

Entrypoint for the image is /start-image.sh (see source on GitHub for details),
this ensures mongod is started, the css and javascript are minified/uglified for
performance, and starts up the meanio app using forever to always keep it running.

The start-image.sh script also provides a hook called /start-image-hook.sh which
can be embedded in downstream (aka docker images using meanio as a base) and
called during the startup of the container.

