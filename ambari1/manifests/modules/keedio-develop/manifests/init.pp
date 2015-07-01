class  keedio-develop  {
  yumrepo { "keedio-1.2-develop":
      baseurl => "http://repo.keedio.org/openbus/1.2/develop",
      descr => "keedio-develop-repository",
      enabled => 1,
      priority => 1,
      gpgcheck => 0
  }



}
