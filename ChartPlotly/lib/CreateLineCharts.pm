package CreateLineCharts;
use strict;
use warnings;

# https://plotly.com/javascript/line-charts/
use Chart::Plotly 'show_plot';
use Chart::Plotly::Image 'save_image';
use Chart::Plotly::Plot;
use Chart::Plotly::Trace::Scatter;

use HTML::Show;

use JSON;
use Data::Dumper;

sub new {
    my ($class, @arguments) = @_;
    my $self = {@arguments};
    bless $self, $class;
    return $self;
}

sub _generate_plot_lines {
    my ($self, $plot, $x_line, $y_line) = @_;

    # https://metacpan.org/pod/Chart::Plotly::Trace::Scatter
    # https://plotly.com/javascript/reference/scatter/
    my $scatter = Chart::Plotly::Trace::Scatter->new(
        x    => $x_line->{data},
        y    => $y_line->{data},
        name => $y_line->{legendName},

        # mode => 'markers',                 # Add markers at data points instead of line
        marker => {
            symbol  => 'diamond',            # Default - circle
            size    => 8,                    # marker size(in px). Default - 6px
            opacity => 0.8,                  # Marker opacity (0-1)
            # color   => 'red'               # Sets the marker color
        },
        opacity => 0.8,
        # text => $x_line->{data}            # Extra text you want to show on mouse hover over all the data points.

        # https://metacpan.org/pod/Chart::Plotly::Trace::Scatter::Line
        line => {
            # width   => 3,                  # Width of line, Default: 2
            # color   => '#45b5c6',          # Color of the line
            shape     => "spline",           # Determines the line shape - one of("linear" | "spline" | "hv" | "vh" | "hvh" | "vhv"), Default: "linear"
            smoothing => 0.5,                # Used only if `shape` is set to "spline", Default: 1
            dash      => "solid",            # Dash style of line - ("solid", "dot", "dash", "longdash", "dashdot", or "longdashdot"). Default: "solid"
            simplify  => JSON::false,        # Simplifies lines by removing nearly-collinear points. Default: true
        }
    );
    return $scatter;
}

sub _add_layout {
    my ($self, $plot, $chart_title, $x_axis_title, $y_axis_title) = @_;
    $plot->layout(
        {
            title => $chart_title,
            # font  => {                          # Sets the global font
            #     family => "Open Sans",          # Default font - ""Open Sans", verdana, arial, sans-serif"
            #     size     => 14                  # default - 12px
            # },
            # https://plotly.com/javascript/legend/
            legend => {
                # orientation => "h",             # Sets the orientation of the legend('v' or 'h'). Default - v(vertical)
                # xanchor     => "left",          # Sets the legend's horizontal position anchor. "left", "center" or "right"
                # yanchor     => "bottom",        # Sets the legend's vertical position anchor. "top", "middle" or "bottom"
                # x           => 0,               # number between or equal to -2 and 3
                #                                 # Sets the x position (in normalized coordinates) of the legend.
                #                                 # Defaults to "1.02" for vertical legends and defaults to "0" for horizontal legends.
                # y           => -0.1,            # number between or equal to -2 and 3
                #                                 # Sets the y position (in normalized coordinates) of the legend.
                #                                 # Defaults to "1" for vertical legends, defaults to "-0.1" for horizontal legends on graphs w/o range sliders and defaults to "1.1" for horizontal legends on graph with one or multiple range sliders.

                bgcolor     => "#ffffff",         # Sets the legend background color . Defaults to `layout.paper_bgcolor`
                bordercolor => "#333333",         # Sets the color of the border enclosing the legend . Default - #444
                borderwidth => 1,                 # Sets the width (in px) of the border enclosing the legend. Default - 0
                font => {                         # Sets the font used to text the legend items.
                    size  => 14,
                    color => "#000000"            # Black
                },
                # title => {                      # Sets the title of the legend. Default - ""
                #     text => "Legend",
                #     font => {size => 14, color => "black"},
                #     side => "top"               # Location of legend's title with respect to the legend items
                # }
            },

            # showlegend => JSON::false,                # Whether you want to display the legend on not. Default - true
            # https://plotly.com/javascript/axes/
            # https://plotly.com/javascript/tick-formatting/
            xaxis => {
                title      => $x_axis_title,            # Text label for x-axis
                type       => "-",                      # x-axis type
                automargin => JSON::true,
                linecolor  => "#333333",                # Sets color of X-axis line
                # titlefont  => {color => '#0066ff'},   # Title font formating
                # tickfont   => {color => '#0066ff'},
                zeroline   => JSON::true,               # Show zero line or not
                zerolinecolor => '#cccccc',             # Assign specific color to zero line
                zerolinewidth => 4,

                # showgrid => JSON::false               # Removes X-axis grid lines
                # rangeslider => { visible => JSON::false },
                # gridcolor   => '#bfbfbf',
                # gridwidth   => 1,
                # tickformat => "YYYY-MM-DD",           # d3-format specifier. If empty or "" plotly will attempt to guess format
                # dtick       => 1                      # step in-between ticks
            },
            yaxis => {
                title      => $y_axis_title,
                tickformat => "",                       # d3-format specifier. If empty or "" plotly will attempt to guess format.
                automargin => JSON::true,
                linecolor  => "#333333",                # Sets color of Y-axis line
                # titlefont  => {color => '#0066ff'},
                # tickfont   => {color => '#0066ff'},
                rangemode  => "tozero",                 # Forced to start from zero. Default - "normal"
                automargin => JSON::true,
                zeroline   => JSON::true,               # Show zero line or not
                # showgrid => JSON::false               # Removes Y-axis grid lines
                # side => "left",                       # Location of y-axis. "left" or "right"
                # gridcolor => '#bfbfbf',               # Assign specific color to grid 
                # gridwidth => 1,
                # dtick => 1                            # step in-between ticks
            },
            paper_bgcolor => "#ffffff",                 # Sets the background color of the paper where the graph is drawn. Default - #FFF
            plot_bgcolor => "#ffffff",                  # Sets the background color of the plotting area in-between x and y axes.
            margin => {                                 # Default(in px): left(80), right(80), top(100), bottom(80)
                'l' => 50,
                'r' => 50,
                't' => 50,
                'b' => 50
            },
            width  => 1000,                             # Sets the plot's width. Default - 700px
            height => 750,                              # Sets the plot's height. Default - 450px
        }
    );
}

sub _add_config {
    my ($self, $plot) = @_;
    # https://plotly.com/javascript/configuration-options/
    my %config = (
        scrollZoom => JSON::true,                   # mousewheel or two-finger scroll zooms the plot
        editable   => JSON::true,                   # In editable mode, users can edit the chart title, axis labels and trace names in the legend
        # staticPlot => JSON::true,                 # Create a static chart
        toImageButtonOptions => {                   # Customize Download Plot Options
            format   => 'svg',                      # one of png, svg, jpeg, webp. Default - png
            filename => 'multi_line_chart',         # Default name - newplot
            height   => 550,
            width    => 800,
            scale    => 1                           # Multiply title/legend/axis/canvas sizes by this factor
        },
        # displayModeBar => JSON::true,             # Force The Modebar at top to Always Be Visible.
                                                    # By default, the modebar is only visible while the user is hovering over the chart.
                                                    # Making it 'false' will never Display The Modebar
        modeBarButtonsToRemove => ['sendDataToCloud'],          # Delete some buttons from the modebar

        showLink        => JSON::true,                          # Display the `Edit Chart` Link
        plotlyServerURL => "https://chart-studio.plotly.com",   # Here you can directly edit your chart in browser
        linkText        => 'Edit chart in chart studio',

        # locale        => 'fr',                    # Change the Default Locale.
                                                    # More info - https://github.com/plotly/plotly.js/blob/master/dist/README.md#to-include-localization
        displaylogo      => JSON::false,            # Hide the Plotly Logo on the Modebar
        # responsive     => JSON::true,             # Responsive to window size
        # doubleClickDelay => 1000,                 # maximum delay between two consecutive clicks to be interpreted as a double-click in ms (default 300 ms)
    );
    $plot->config(\%config);
}

sub generate_line_chart {
    my ($self, $chart_out_file, $chart_data) = @_;

    my $x_axis = $chart_data->{domainAxis};
    my $y_axis = $chart_data->{rangeAxis};

    my $plot = Chart::Plotly::Plot->new();
    foreach my $y_line (keys %{$y_axis->{lines}}) {
        my $scatter = $self->_generate_plot_lines($plot, $x_axis, $y_axis->{lines}->{$y_line});
        $plot->add_trace($scatter);
    }

    $self->_add_layout($plot, $chart_data->{title}, $x_axis->{label}, $y_axis->{label});

    $self->_add_config($plot);

    my $html = $plot->html(
        div_id => 'my_div_id',                          # Id of the div, in which you want your chart to be embedded
        load_plotly_using_script_tag => 'embed'         # Can be : 1 or cdn, embed, module_dist.
                                                        # * By default, it is 1(cdn) meaning it will load plotly.js using cdn link.
                                                        # * 'embed' will take it from the plotly.js that is shipped wth Chart::Plotly and paste it within <script> tag.
                                                        # * 'module_dist' is similar to 'embed' except it will provide the source in <script src="file://">.
                                                        # Please note that using 'module_dist' will show the actual location of the file on your location machine(e.g. /usr/lib/perl/5.30/site/lib/Chart-Plotly/plotly.js/plotly.min.js).
                                                        # So, beware of this as you will be showing this location in your browser
    );

    # Returns the structure suitable to serialize to JSON corresponding to the plot
    # print Dumper($plot->TO_JSON);

    # Returns the plot serialized in JSON . Not suitable to use in nested structures
    # print Dumper($plot->to_json_text);

    # Opens the plot or plots in a browser locally.
    # Both are equal. In second statement we are just updating the div id with user defined one and determining how to load plotly.js
    show_plot($plot);
    HTML::Show::show($html);

    # https://metacpan.org/pod/Chart::Plotly::Image#save_image
    save_image(
        file   => $chart_out_file,          # Referring to a local filesystem path
        format => "png",                    # Supported formats are png, jpeg, webp, svg, pdf, eps.
                                            # By default it's inferred from the specified file name extension
        scale => 1,                         # Multiply title/legend/axis/canvas sizes by this factor
        plot  => $plot,
        # width  => 1024,                   # Sets the image width
        # height => 768,                    # Sets the image height
        engine => 'auto'
    );
}

1;
