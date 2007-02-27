#!/usr/bin/perl

use strict;
use warnings;

$\="\n";

sub flatten_attributes {
    my ($attrs) = @_;
    return "" unless defined $attrs;
    " " . (join " " => map { $_ . '="' . $attrs->{$_} . '"'} keys %$attrs);
}

sub mk_tag {
    my ($name, $attributes, $children) = @_;
    '<' 
    . $name 
    . flatten_attributes($attributes) 
    . ($children 
        ? ('>' . (join "" => @$children) . '</' . $name . '>') 
        : '/>')
}

sub workbook { 
    my $children = shift;
    mk_tag('workbook', undef, $children);
}

sub formatter {
    my ($attributes, $children) = @_;
    mk_tag('format', $attributes, $children);
}

sub worksheet {
    my ($attributes, $children) = @_;
    mk_tag('worksheet', $attributes, $children);
}

sub row {
    my $children = shift;
    mk_tag('row', undef, $children);
}

sub cell {
    my $attributes = shift;
    mk_tag('cell', $attributes, undef);
}

my $params = {
    workbook_title => 'Title',
    positive_title => 'Positive',
    negative_title => 'Negative',
    impacts => [
        { positive => 10, negative => -10 },
        { positive => 10, negative => -10 },
        { positive => 10, negative => -10 },                
    ]
};

print workbook([
    formatter({ align => "left", font => "Ariel", text_wrap => 1, size => 10 }, [
        worksheet({ name => $params->{workbook_title}, landscape => 1 }, [
            formatter({ bg_color => 'green', color => 'white', border => 1 }, [
                row([
                    cell({ text => $params->{positive_title}, width => 40 }),
                    cell({ text => $params->{negative_title}, width => 40 }),
                ])
            ]),
            formatter({ border => 1, indent => 1 }, [
                map {
                    row([
                        cell({ text => $_->{positive} }),
                        cell({ text => $_->{negative} }),                            
                    ])
                } @{$params->{impacts}}
            ])
        ])
    ])
]);

