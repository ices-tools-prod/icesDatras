# icesDatras 1.4.1 (2023-05-08)

- Fixed bug in getFlexFile.

# icesDatras 1.4.0.9000 (2022-02-18)

- Same as previous version.

# icesDatras 1.4.0 (2022-02-10)

- added functions getCPUEAge, getCPUELength, getFlexFile, getLTassessment
- fixed bug in catch weights and updated documentation

# icesDatras 1.3-0 (2019-03-12)

- Added function getIndices() to get age based indices of abundance by species,
  survey and year.
- Made all examples 'dontrun' as taking a while due to slow response time of
  web server.
- Added function getIndices() to get age based indices of abundance by species,
  survey and year.
- Made all examples 'dontrun' as taking a while due to slow response time of
  web server

# icesDatras 1.2-0 (2017-01-10)

- removed dependency on XML and RCurl by using text regex and download.file -> scan.
  If download.file fails then url() is used to make the connection.

# icesDatras 1.1-1 (2016-09-14)

- Improved XML parsing, exploiting structure of data and that we can
  delete XML nodes once read.

- Added function to extract catch weigthts by species and haul.

# icesDatras 1.1-0 (2016-08-17)

- New argument 'surveys' in function getDatrasDataOverview() allows faster
  overviews for one or few surveys.
- Improved XML parsing, so both leading and trailing white space is removed.
- Improved XML parsing, so -9 and "" is converted to NA.
- Improved XML parsing, so data frame columns are automatically coerced to the
  appropriate storage mode (character, numeric, integer).

# icesDatras 1.0-3 (2016-08-09)

- Fixed bug where code assumed stringsAsFactors = FALSE by default.
- Remove trailing white space from HHdata table entries.
- Added function getDATRAS() from retired package rICES to extract multiple
  years and quarters.

# icesDatras 1.0-0 (2016-08-04)

- Initial release.
