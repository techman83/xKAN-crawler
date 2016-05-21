package App::KSP_CKAN::Crawler::Schema::Result::CKAN_meta;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table('ckan_meta');
__PACKAGE__->add_columns(
                        id => { 
                          data_type => 'integer',
                          is_nullable => 0,
                          is_auto_increment => 1,
                        },
                        identifier => { 
                          data_type => 'varchar',
                          size      => 255,
                          is_nullable => 0,
                        },
                        file  => { 
                          data_type => 'varchar',
                          size      => 255,
                          is_nullable => 0,
                        },
                        download_sha1  => { 
                          data_type => 'char',
                          size      => 40,
                        },
                        last_checked => { 
                          data_type => 'datetime',
                        },
                        mirrored => { 
                          data_type => 'bool',
                        },
                        dead_url => { 
                          data_type => 'bool',
                        },
                        last_error  => { 
                          data_type => 'varchar',
                          size      => 255,
                        },
                        deleted => { 
                          data_type => 'bool',
                        },
                      );

__PACKAGE__->set_primary_key('id');

1;
