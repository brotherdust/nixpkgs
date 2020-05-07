{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file
, json_c
, python3
, readline
, c-ares
, perl
, libcap
, pcapc
, libnl
, libyang
, yacc
, flex
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "frr";
  version = "7.3";

  src = fetchFromGitHub {
    owner = "FRRouting";
    repo = "frr";
    rev = "frr-7.3";
    sha256 = "1d7yia02z0h9pifl1gl1q714x4z7mhnfmdhyp8wc4d6rr1iwj8xf";
  };

  buildInputs = [ 
    autoreconfHook
    file
    json_c
    python3
    readline
    c-ares
    libcap
    pcapc
    libnl
    perl
    yacc
    flex
    sqlite
   ];

  nativeBuildInputs = [ pkgconfig libyang ];

  configureFlags = [
    "--disable-doc"
    "--sysconfdir=/etc/frr"
    "--localstatedir=/var/run/frr"
    # "--enable-systemd"
    "--enable-multipath=64"
    "--enable-config-rollbacks"
    # "--with-libpam"
    # "--enable-pcreposix"
    "--enable-user=frr"
    "--enable-group=frr"
    "--enable-vty-group=frrvty"
  ];

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
    configureFlags="$configureFlags --sbindir=$out/usr/lib/frr --enable-exampledir=$out/usr/share/doc/frr/examples"
  '';

  enableParallelBuilding = true;
  # dontInstall = true;

  meta = with stdenv.lib; {
    description = "FRRouting";
    longDescription = ''
      FRR is free software that implements and manages various IPv4 and 
      IPv6 routing protocols. It runs on nearly all distributions of 
      Linux and BSD as well as Solaris and supports all modern CPU 
      architectures.      
    '';
    homepage = "https://frrouting.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ brotherdust ];
  };
}
