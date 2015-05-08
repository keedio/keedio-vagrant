class  keedio  {

 yumrepo { "keedio-1.2":
      baseurl => "http://repo.keedio.org/openbus/1.2/rpm",
      descr => "keedio-repository",
      enabled => 1,
      gpgcheck => 0
  }
  yumrepo { "keedio-1.2i-updates":
      baseurl => "http://repo.keedio.org/openbus/1.2/updates",
      descr => "keedio-updates-repository",
      enabled => 1,
      gpgcheck => 0
  }




}
