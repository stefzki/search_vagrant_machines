# -*- mode: ruby -*-

package { 'libnss-mdns':
	ensure  => present,
}


group { 'puppet':
	ensure => present,
}

exec { 'update':
	command => '/usr/bin/apt-get update',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
}

package { 'java7-runtime-headless':
	ensure  => installed,
	require => Exec['update'],
}

exec { 'extract-jdk': 
	command => '/bin/tar -C /opt -xzf /vagrant/jdk-7*.tar.gz',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
}

exec { 'link-jdk': 
	command => '/bin/ln -s /opt/jdk1* /opt/jdk7',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
	creates => '/opt/jdk7',
	require => Exec['extract-jdk']
}

file { '/usr/lib/jvm':
	ensure  => directory,
	require => Exec['link-jdk']
}

exec { 'link-default-java': 
	command => 'ln -s /opt/jdk7 /usr/lib/jvm/default-java',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
	creates => '/usr/lib/jvm/default-java',
	require => File['/usr/lib/jvm']
}

file { '/etc/profile.d/java.sh':
	ensure  => present,
	mode    => '0755',
	source  => '/vagrant/manifests/java.sh',
	require => Exec['link-jdk']
}

file { '/etc/environment':
	ensure  => present,
	mode    => '0644',
	source  => '/vagrant/manifests/environment',
	require => Exec['link-jdk']
}

exec { 'wget':
	command => 'wget -O /vagrant/elasticsearch.deb http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.4.deb',
	path    => '/usr/local/bin/:/bin/:/usr/bin/',
	creates => '/vagrant/elasticsearch.deb', 	
	require => [ Package['java7-runtime-headless'], Exec['update'], File['/etc/environment'] ],
}

exec { 'install':
	command => 'dpkg -i /vagrant/elasticsearch.deb',
	path    => '/usr/local/bin/:/bin/:/usr/bin/:/usr/sbin/:/sbin/',
	creates => '/etc/init.d/elasticsearch', 	
	require => Exec['wget'],
}

file {"/etc/elasticsearch/elasticsearch.yml":
	content => template("/vagrant/manifests/elasticsearch.erb"),
	require => Exec["install"],
}

file {"/etc/elasticsearch/logging.yml":
	content => template("/vagrant/manifests/logging.erb"),
	require => Exec["install"],
}

exec { 'install-eshead':
	command => '/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head',
	path    => '/usr/local/bin/:/bin/:/usr/bin/:/usr/sbin/:/sbin/',
	creates => '/usr/share/elasticsearch/plugins/head', 	
	require => Exec['install'],
}

exec { 'start-es':
	command => '/etc/init.d/elasticsearch restart',
	path    => '/usr/local/bin/:/bin/:/usr/bin/:/usr/sbin/:/sbin/',
	require => Exec['install-eshead'],
}


