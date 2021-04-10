package MojoApp::Controller::Charts;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON qw(decode_json encode_json);

sub read_json_file ($self, $json_file) {

    open(my $in, '<', $json_file) or $self->app->log->error("Unable to open file $json_file : $!");
    my $json_text = do { local $/ = undef; <$in>; };
    close($in) or $self->app->log->error("Unable to close file : $!");

    my $config_data = decode_json($json_text);
    return $config_data;
}

sub create_multi_line_chart ($self) {
    my $data_in_json = read_json_file($self, "etc/input_data.json");

    $self->render(template => 'charts/multi_line_chart', chart_data => encode_json($data_in_json));
}

1;
