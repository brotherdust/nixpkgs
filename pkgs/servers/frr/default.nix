{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
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
    # "--enable-exampledir=/usr/share/doc/frr/examples"
    "--disable-doc"
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
    configureFlags="$configureFlags --sbindir=$out/usr/lib/frr --sysconfdir=$out/etc/frr --localstatedir=$out/var/run/frr"
  '';

  enableParallelBuilding = true;

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
