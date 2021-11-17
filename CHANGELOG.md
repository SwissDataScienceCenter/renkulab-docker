#  (2021-11-17)



## [0.10.2](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.10.1...0.10.2) (2021-11-17)


### Bug Fixes

* image build and bump base image version ([#197](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/197)) ([cddd6a9](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/cddd6a9904d1d30e30387e1829143ae763ad1bd7))
* renku not found error ([#193](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/193)) ([5f9ee64](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/5f9ee642c46610b55be63e9b51b9e076e4211c4d))



## [0.10.1](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.10.0...0.10.1) (2021-09-09)


### Bug Fixes

* allow rstudio to run in an iframe ([6ac7fb8](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/6ac7fb84525c61cb9d3df29bca084d0eea3f5bfd))
* remove logic to avoid race condition in entrypoint ([621e208](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/621e2086126c1ed12a74ebaf303ee0130f534a84))
* use virtualenv manually instead of pipx for renku install ([ba6cccc](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/ba6ccccc3b8db039f8f914f61d4fb42984c58d6b))



# [0.10.0](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.9.0...0.10.0) (2021-09-01)


### Bug Fixes

* avoid race-condition in entrypoint ([37143ec](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/37143ec7b978bc34edb66d751e140eece137281b))


### Features

* add base image for batch execution ([#173](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/173)) ([141a832](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/141a83208d40c2feece6f9fe67447b7dbe0febaf)), closes [#172](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/172)
* make images fully amalthea ready ([1dd8154](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/1dd8154b2c1c066e9aa37691ea6f03ae3e504300))



# [0.9.0](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.8.0...0.9.0) (2021-07-22)


### Features

* add acceptance tests ([#175](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/175)) ([add75b1](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/add75b189ec5fecfb0d7879d14db67583c04ae69))



# [0.8.0](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.7...0.8.0) (2021-07-09)


### Bug Fixes

* replace ~ with ${HOME} in PATH ([#169](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/169)) ([23d30d4](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/23d30d4dbc55bc434c2af8f8de6967f4a7e7c898))


### Features

* upgrade JupyterLab to 3.0.x ([#137](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/137)) ([274c0d4](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/274c0d447c32218949cccad678e893cda6e6e4e2))



## [0.7.7](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.6...0.7.7) (2021-06-09)


### Bug Fixes

* **r:** add star-notebook.sh script ([2debcbe](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/2debcbeb33c28cf58158e9760b1e7751ba1f066c))


### Features

* add jq to base py ([#165](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/165)) ([e1e7d32](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/e1e7d324d287283bd0003a7426982f06dd47c41f))
* adding calcutta default fonts for vnc ([#167](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/167)) ([a3294af](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/a3294af74557ff5c25d8162266bbd6a5f7683567))
* vnc upgrades  ([#156](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/156)) ([cc2b9ad](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/cc2b9ad3a6425286509b2b0a8579b0a09627d9cb))



## [0.7.6](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.5...0.7.6) (2021-05-10)


### Features

* add renku wallpaper and set it as the default ([#146](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/146)) ([c0d59fa](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/c0d59fa9e3f5dd30cd52355521c1548c4cbb6052))
* update fonts; add gnome-terminal, git-gui, gitk and their desktop icons ([#145](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/145)) ([faae1f6](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/faae1f6ce2f099289f86c81e3e328d20acab285e))



## [0.7.5](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.4...0.7.5) (2021-04-06)


### Features

* add vnc-enabled base image ([#143](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/143)) ([0a667be](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/0a667be081140afaea83fd0a58c0cfe7ec51b3be))



## [0.7.4](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.3...0.7.4) (2021-02-10)


### Features

* add vscode install script ([#134](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/134)) ([5534f22](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/5534f224e03e619373c88cb541f4883f60ca5c9e))



## [0.7.3](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.2...0.7.3) (2020-11-12)


### Bug Fixes

* do the renku-env after git credentials are configured ([#133](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/133)) ([f3a7a37](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/f3a7a37c4dde34872109c653604f8ae7fc3c47b5))



## [0.7.2](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.1...0.7.2) (2020-11-02)


### Bug Fixes

* ensure local/bin is in PATH ([#132](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/132)) ([158d97a](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/158d97a120ca4c1b9925ee1d7b63276064f95642))



## [0.7.1](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.7.0...0.7.1) (2020-10-21)


### Bug Fixes

* global git credentials and add post-init functionality ([#130](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/130)) ([a1121ee](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/a1121eede98823f15aaa46e8f61546126749cf4f))
* pin RStudio version ([#125](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/125)) ([e9a1941](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/e9a1941c7b125eadf878ccdef23f962b6b0a3ebf)), closes [#124](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/124)



# [0.7.0](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.6.3...0.7.0) (2020-09-30)



## [0.6.3](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.6.2...0.6.3) (2020-05-26)



## [0.6.2](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.6.1...0.6.2) (2020-04-22)


### Bug Fixes

* restore makefile commands ([#82](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/82)) ([408e107](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/408e107f507bc065ded688d35e69f8255919c05a)), closes [#81](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/81)


### Features

* add julia ([#84](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/84)) ([031fa69](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/031fa698444a460ca9d7acae03a44cd37b5e5db2))



## [0.6.1](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.6.0...0.6.1) (2020-03-31)



# [0.6.0](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.5.2...0.6.0) (2020-03-26)



## [0.5.2](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.5.1...0.5.2) (2020-03-06)



# [0.5.0](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.4.4...0.5.0) (2020-03-03)



## [0.4.4](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.4.3...0.4.4) (2020-02-12)


### Features

* adding a bioconductor base ([#67](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/67)) ([085b7e7](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/085b7e7dd064fdfefc4d7cdce252477f32555957))
* inject environment setup into session ([b55a29e](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/b55a29e5c0f417971585b60d5e716859ba8b4ea2)), closes [#64](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/64)



## [0.4.3](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.4.2...0.4.3) (2019-11-26)


### Bug Fixes

* enable travis tags deploy ([af865dd](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/af865dd4bfb18197b46427bca659715351ce8832))



## [0.4.2](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.4.1...0.4.2) (2019-11-05)



# [0.4.0](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.8...0.4.0) (2019-10-28)



## [0.3.8](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.7...0.3.8) (2019-09-19)



## [0.3.7](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.6...0.3.7) (2019-08-23)


### Bug Fixes

* avoid lab rebuild on server launch ([0d77ab3](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/0d77ab38ccabb75782925cbcbb9b1083c6111a0c)), closes [#52](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/52)



## [0.3.6](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.5...0.3.6) (2019-08-08)


### Bug Fixes

* pin r-base to avoid dependency issues ([133660e](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/133660e5d31c5aee5921ff49c93c9168d4255e86))



## [0.3.5](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.4...0.3.5) (2019-07-26)


### Bug Fixes

* remove jupyterlab extension ([143bf0b](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/143bf0b05c99ae30e450da71ccaff4ce866ba61c)), closes [#39](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/39) [#40](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/40)


### Features

* add graphviz to base image ([acab9d7](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/acab9d7882b3e44b88ea23c23c8b8d4791f5729d))
* added pre-stop pod lifecycle script ([2a32302](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/2a32302666145c0c519fd8e747689c0bf7e205df))



## [0.3.4](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.3...0.3.4) (2019-04-02)



## [0.3.3](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.2...0.3.3) (2019-03-07)


### Bug Fixes

* resolve build problems and psutil dependency ([#15](https://github.com/SwissDataScienceCenter/renkulab-docker/issues/15)) ([679b6b2](https://github.com/SwissDataScienceCenter/renkulab-docker/commit/679b6b289ac3238f340ddf953f0ba74b8a9bb4b1))



## [0.3.2](https://github.com/SwissDataScienceCenter/renkulab-docker/compare/0.3.1...0.3.2) (2018-11-28)



