# Topogical Covidnet (topo_covidnet)

topo_covidnet is the repository that is required to run the tcovidnet.sh workflow found in this workflow. These directions will create a new instance on ChRIS locally.

1. Setting up ChRIS_ultron_backend
    * `cd`
    * `git clone https://github.com/FNNDSC/ChRIS_ultron_backend`
    * `cd ChRIS_ultron_backend`
    * `./unmake.sh ; sudo rm -fr FS; rm -fr FS; ./make.sh -U -I -i`
    * Move `tupload.sh` from this repository to the `ChRIS_ultron_backend` repository. This is so that tupload.sh has the correct files available to run correctly.
    * `cd ChRIS_ultron_backend`
    * `./tupload.sh`
    * The plugins required to run this workflow are now installed. If it gives errors on the first time running, run it again. This is to register the plugins with your instance on ChRIS.

2. Setting up ChRIS_ui frontend
    * `cd`
    * `git clone github.com/FNNDSC/ChRIS_ui`
    * `cd ChRIS_ui`
    * `docker run --rm -ti -v $(pwd):/home/localuser -p 3000:3000 -u $(id -u):$(id -g) --name chris_ui fnndsc/chris_ui:dev`
    * The ChRIS backend is now linked to the frontend UI. Go to localhost:3000 to view. Login with chris:chris1234

3. Running tcovidnet.sh
    * `cd topo_covidnet`
    * `./tcovidnet.sh -a localhost`
    * Go to localhost:3000 to see the workflow being built.



Once one has set up their ChRIS_ultron_backend using github.com/FNNDSC/ChRIS_ultron_backend and ChRIS_ui frontend using github.com/FNNDSC/CHRIS_ui, they should copy 