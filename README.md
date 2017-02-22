[![Build Status](https://travis-ci.org/ices-tools-prod/icesDatras.svg?branch=master)](https://travis-ci.org/ices-tools-prod/icesDatras)
[![codecov](https://codecov.io/gh/ices-tools-prod/icesDatras/branch/master/graph/badge.svg)](https://codecov.io/gh/ices-tools-prod/icesDatras)
[![local release](https://img.shields.io/github/release/ices-tools-prod/icesDatras.svg?maxAge=2592001)](https://github.com/ices-tools-prod/icesDatras/tree/1.2-0)
[![CRAN Status](http://www.r-pkg.org/badges/version/icesDatras)](https://cran.r-project.org/package=icesDatras)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/icesDatras)](https://cran.r-project.org/package=icesDatras)
[![License](https://img.shields.io/badge/license-GPL%20(%3E%3D%202)-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://www.ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://www.ices.dk/Pages/default.aspx)

icesDatras
======

icesDatras provides R functions that access the
[web services](https://datras.ices.dk/WebServices/Webservices.aspx) of the
[ICES](http://www.ices.dk/Pages/default.aspx) [DATRAS](http://datras.ices.dk)
trawl survey database.

icesDatras is implemented as an [R](https://www.r-project.org) package and
available on [CRAN](https://cran.r-project.org/package=icesDatras).

Installation
------------

icesDatras can be installed from CRAN using the `install.packages` command:

```R
install.packages("icesDatras")
```

Usage
-----

For a summary of the package:

```R
library(icesDatras)
?icesDatras
```

References
----------

ICES DATRAS database:
[http://datras.ices.dk](http://datras.ices.dk)

ICES DATRAS database web services:
[https://datras.ices.dk/WebServices/Webservices.aspx](https://datras.ices.dk/WebServices/Webservices.aspx)

Development
-----------

icesDatras is developed openly on
[GitHub](https://github.com/ices-tools-prod/icesDatras).

Feel free to open an
[issue](https://github.com/ices-tools-prod/icesDatras/issues) there if you
encounter problems or have suggestions for future versions.

The current development version can be installed using:

```R
library(devtools)
install_github("ices-tools-prod/icesDatras")
```
