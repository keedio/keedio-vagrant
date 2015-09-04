class  keedio  {

 yumrepo { "keedio-1.2":
      baseurl => "http://repo.keedio.org/openbus/1.2/rpm",
      descr => "keedio-repository",
      enabled => 1,
      priority => 1,
      gpgcheck => 0
  }
  yumrepo { "keedio-1.2-updates":
      baseurl => "http://repo.keedio.org/openbus/1.2/updates",
      descr => "keedio-updates-repository",
      enabled => 1,
      priority => 1,
      gpgcheck => 0
  }
  if hiera(development) {
  yumrepo { "keedio-1.2-develop":
      baseurl => "http://repo.keedio.org/openbus/1.2/develop",
      descr => "keedio-develop-repository",
      enabled => 1,
      priority => 1,
      gpgcheck => 0
  }
  }


}
