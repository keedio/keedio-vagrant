class  keedio  {

 if hiera(disable_repos) == true {
 $isenabled = 0
 }
 else {
 $isenabled = 1
 }

 yumrepo { "keedio-1.2":
      baseurl => "http://repo.keedio.org/openbus/1.2/rpm",
      descr => "keedio-repository",
      enabled => $isenabled,
      priority => 1,
      gpgcheck => 0
  }
  yumrepo { "keedio-1.2-updates":
      baseurl => "http://repo.keedio.org/openbus/1.2/updates",
      descr => "keedio-updates-repository",
      enabled => $isenabled,
      priority => 1,
      gpgcheck => 0
  }
  if hiera(development) {
  yumrepo { "keedio-1.2-develop":
      baseurl => "http://repo.keedio.org/openbus/1.2/develop",
      descr => "keedio-develop-repository",
      enabled => $isenabled,
      priority => 1,
      gpgcheck => 0
  }
  }


}
