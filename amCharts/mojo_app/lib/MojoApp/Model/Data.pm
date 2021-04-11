package MojoApp::Model::Data;

use strict;
use warnings;
use experimental qw(signatures);
use Mojo::JSON qw(decode_json);

sub new ($class) {
    my $self = {};
    bless $self, $class;
    return $self;
}

sub _read_json_file ($self, $json_file) {
    open(my $in, '<', $json_file) or $self->app->log->error("Unable to open file $json_file : $!");
    my $json_text = do { local $/ = undef; <$in>; };
    close($in) or $self->app->log->error("Unable to close file : $!");

    my $config_data = decode_json($json_text);
    return $config_data;
}

sub get_data ($self) {
    my $data_in_json = $self->_read_json_file("etc/input_data.json");

    return $data_in_json;
}

1;
