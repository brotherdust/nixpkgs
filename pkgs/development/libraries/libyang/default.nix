{
  stdenv
, fetchFromGitHub 
, cmake
, pkgconfig
, boost
, pcre
, cmocka
}:

stdenv.mkDerivation rec {
  pname = "libyang";
  version = "1.0.130";
  # NIX_DEBUG = 1;

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v1.0.130";
    sha256 = "0hvydcblcbfnm673y1al462cg9k6h2zyzxl5hgfcv3gcqgdcyzvp";
  };

  nativeBuildInputs = [ cmake pkgconfig boost pcre cmocka ];

  cmakeFlags = [
    "-DENABLE_CACHE=1"
    "-DENABLE_LATEST_REVISIONS=1"
    "-DENABLE_BUILD_TESTS=ON"
    "-DENABLE_LYD_PRIV=ON"
  ];

  meta = with stdenv.lib; {
    description = "YANG data modeling language library ";
    longDescription = ''
      libyang is a YANG data modelling language parser and toolkit written 
      (and providing API) in C. The library is used e.g. in libnetconf2, 
      Netopeer2, sysrepo and FRRouting projects.      
    '';
    homepage = "https://github.com/CESNET/libyang";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ brotherdust ];
  };
}