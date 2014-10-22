<TeXmacs|1.0.7.20>

<style|<tuple|generic|puredoc>>

<\body>
  <hlink|toc|#faust2pd-toc> <hlink|index|genindex.tm>
  <hlink|modules|pure-modindex.tm> \| <hlink|next|pd-faust.tm> \|
  <hlink|previous|pure-tk.tm> \| <hlink|Pure Language and Library
  Documentation|index.tm>

  <section*|faust2pd: Pd Patch Generator for
  Faust<label|faust2pd-pd-patch-generator-for-faust>>

  Version 2.9, October 22, 2014

  Albert Graef \<less\><hlink|aggraef@gmail.com|mailto:aggraef@gmail.com>\<gtr\>

  This package contains software which makes it easier to use Faust DSPs with
  Pd and the Pure programming language. The main component is the faust2pd
  script which creates GUI wrappers for Faust DSPs. The package also includes
  a bunch of examples. The software is distributed under the GPL; see the
  COPYING file for details.

  <with|font-series|bold|Note:> This faust2pd version is written in Pure and
  was ported from an earlier version written in Pure's predecessor Q. The
  version of the script provided here should be 100% backward-compatible to
  those previous versions, except for the following changes:

  <\itemize>
    <item>The (rarely used) -f (a.k.a. \Ufake-buttons) option was renamed to
    -b.

    <item>A new -f (a.k.a. \Ufont-size) option was added to change the font
    size of the GUI elements.

    <item>Most command line options can now also be specified using special
    <verbatim|[pd:...]> tags in the Faust source.
  </itemize>

  Also note that you can now run the script on 64 bit systems (Q never worked
  there).

  As of version 2.1, the faust2pd script is now compiled to a native
  executable before installation. This makes the program start up much
  faster, which is a big advantage because most xml files don't take long to
  be processed.

  <subsection|Copying<label|copying>>

  Copyright (c) 2009-2014 by Albert Graef.

  faust2pd is free software: you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation, either version 3 of the License, or (at your option)
  any later version.

  faust2pd is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public License along
  with this program. If not, see \<less\><hlink|http://www.gnu.org/licenses/|http://www.gnu.org/licenses/>\<gtr\>.

  <subsection|Requirements<label|requirements>>

  faust2pd is known to work on Linux, Mac OS X, and Windows, and there
  shouldn't be any major roadblocks preventing it to work on other systems
  supported by Pure.

  The faust2pd script is written in the <hlink|Pure|http://purelang.bitbucket.org>
  programming language and requires Pure's XML module, so you need to install
  these to make it work. Install the latest pure*.tar.gz and pure-xml*.tar.gz
  packages and you should be set. (Pure 0.47 or later is required.) Also make
  sure that the LLVM base package is installed, as described in the Pure
  INSTALL file, some LLVM utilities are needed to make Pure's batch compiler
  work.

  To run the seqdemo example, you'll also need the Pd Pure external
  (pd-pure*.tar.gz), also available at the
  <hlink|Pure|http://purelang.bitbucket.org> website.

  To compile the examples, you'll need GNU C++ and make,
  <hlink|Pd|http://puredata.info> and, of course,
  <hlink|Faust|http://faudiostream.sf.net>. Make sure you get a recent
  version of Faust; Faust releases \<gtr\>0.9.8 include the puredata
  architecture necessary to create Pd externals from Faust DSPs.

  <subsection|Installation<label|installation>>

  Get the latest source from <hlink|https://bitbucket.org/purelang/pure-lang/downloads/faust2pd-2.9.tar.gz|https://bitbucket.org/purelang/pure-lang/downloads/faust2pd-2.9.tar.gz>.

  Run <verbatim|make> and <verbatim|make> <verbatim|install> to compile and
  install the faust2pd program on your system. You can set the installation
  prefix by running make as <verbatim|make> <verbatim|install>
  <verbatim|prefix=/some/path>. Default installation prefix is /usr/local,
  faust2pd is installed in the bin directory below that.

  Optionally, you can also run <verbatim|make> <verbatim|install-pd> to copy
  the supporting Pd abstractions (faust-*.pd) to your lib/pd/extra directory,
  so that you can use the patches generated by faust2pd without copying these
  abstractions to your working directory. The Makefile tries to guess the
  prefix of your Pd installation, if it guesses wrong, you can specify the
  prefix explicitly by running make as <verbatim|make> <verbatim|install-pd>
  <verbatim|pdprefix=/some/path>.

  The included faustxml.pure script provides access to Faust-generated dsp
  descriptions in xml files to Pure scripts. This module is described in its
  own <hlink|appendix|#appendix-faustxml> below. It may have uses beyond
  faust2pd, but isn't normally installed. If you want to use this module, you
  can just copy it to your Pure library directory.

  <subsection|Quickstart<label|quickstart>>

  Run <verbatim|make> <verbatim|examples> to compile the Faust examples
  included in this package to corresponding Pd plugins. After that you should
  be able to run the patches in the various subdirectories of the examples
  directory. Everything is set up so that you can try the examples
  ``in-place'', without installing anything except the required software as
  noted in <hlink|Requirements|#requirements> above. You can also run
  <verbatim|make> <verbatim|realclean> before <verbatim|make> to regenerate
  everything from scratch (this requires faust2pd, so this will only work if
  you already installed the Pure interpreter).

  Faust Pd plugins work in much the same way as the well-known
  plugin<math|\<sim\>> object (which interfaces to LADSPA plugins), except
  that each Faust DSP is compiled to its own Pd external. Under Linux, the
  basic compilation process is as follows (taking the freeverb module from
  the Faust distribution as an example):

  <\verbatim>
    # compile the Faust source to a C++ module using the "puredata"
    architecture

    faust -a puredata.cpp freeverb.dsp -o freeverb.cpp

    # compile the C++ module to a Pd plugin

    g++ -shared -Dmydsp=freeverb freeverb.cpp -o freeverb~.pd_linux
  </verbatim>

  By these means, a Faust DSP named <verbatim|xyz> with n audio inputs and m
  audio outputs becomes a Pd object <verbatim|xyz~> with n+1 inlets and m+1
  outlets. The leftmost inlet/outlet pair is for control messages only. This
  allows you to inspect and change the controls the unit provides, as
  detailed below. The remaining inlets and outlets are the audio inputs and
  outputs of the unit, respectively. For instance, <verbatim|freeverb.dsp>
  becomes the Pd object <verbatim|freeverb~> which, in addition to the
  control inlet/outlet pair, has 2 audio inputs and outputs.

  When creating a Faust object it is also possible to specify, as optional
  creation parameters, an extra unit name (this is explained in the following
  section) and a sample rate. If no sample rate is specified explicitly, it
  defaults to the sample rate at which Pd is executing. (Usually it is not
  necessary or even desirable to override the default choice, but this might
  occasionally be useful for debugging purposes.)

  As already mentioned, the main ingredient of this package is a Pure script
  named ``faust2pd'' which allows you to create Pd abstractions as
  ``wrappers'' around Faust units. The wrappers generated by faust2pd can be
  used in Pd patches just like any other Pd objects. They are much easier to
  operate than the ``naked'' Faust plugins themselves, as they also provide
  ``graph-on-parent'' GUI elements to inspect and change the control values.

  The process to compile a plugin and build a wrapper patch is very similar
  to what we've seen above. You only have to add the -xml option when
  invoking the Faust compiler and run faust2pd on the resulting XML file:

  <\verbatim>
    # compile the Faust source and generate the xml file

    faust -a puredata.cpp -xml freeverb.dsp -o freeverb.cpp

    # compile the C++ module to a Pd plugin

    g++ -shared -Dmydsp=freeverb freeverb.cpp -o freeverb~.pd_linux

    # generate the Pd patch from the xml file

    faust2pd freeverb.dsp.xml
  </verbatim>

  Please see <hlink|Wrapping DSPs with faust2pd|#wrapping-dsps-with-faust2pd>
  below for further details.

  Note that, just as with other Pd externals and abstractions, the compiled
  .pd_linux modules and wrapper patches must be put somewhere where Pd can
  find them. To these ends you can either move the files into the directory
  with the patches that use the plugin, or you can put them into the
  lib/pd/extra directory or some other directory on Pd's library path for
  system-wide use.

  Also, faust2pd-generated wrappers use a number of supporting abstractions
  (the faust-*.pd files in the faust2pd sources), so you have to put these
  into the directory of the main patch or install them under lib/pd/extra as
  well. (The <verbatim|make> <verbatim|pd-install> step does the latter, see
  <hlink|Installation|#installation> above.)

  <subsection|Control Interface<label|control-interface>>

  The control inlet of a Faust plugin understands messages in one of the
  following forms:

  <\itemize>
    <item><verbatim|bang>, which reports all available controls of the unit
    on the control outlet, in the form: <verbatim|type> <verbatim|name>
    <verbatim|val> <verbatim|init> <verbatim|min> <verbatim|max>
    <verbatim|step>, where <verbatim|type> is the type of the control as
    specified in the Faust source (<verbatim|checkbox>, <verbatim|nentry>,
    etc.), <verbatim|name> its (fully qualified) name, <verbatim|val> the
    current value, and <verbatim|init>, <verbatim|min>, <verbatim|max>,
    <verbatim|step> the initial value, minimum, maximum and stepsize of the
    control, respectively.

    <item><verbatim|foo> <verbatim|0.99>, which sets the control
    <verbatim|foo> to the value 0.99, and outputs nothing.

    <item>Just <verbatim|foo>, which outputs the (fully qualified) name and
    current value of the <verbatim|foo> control on the control outlet.
  </itemize>

  Control names can be specified in their fully qualified form, like e.g.
  <verbatim|/gnu/bar/foo> which indicates the control <verbatim|foo> in the
  subgroup <verbatim|bar> of the topmost group <verbatim|gnu>, following the
  hierarchical group layout defined in the Faust source. This lets you
  distinguish between different controls with the same name which are located
  in different groups. To find out about all the controls of a unit and their
  fully qualified names, you can bang the control inlet of the unit as
  described above, and connect its control outlet to a <verbatim|print>
  object, which will cause the descriptions of all controls to be printed in
  Pd's main window. (The same information can also be used, e.g., to
  initialize GUI elements with the proper values. Patches generated with
  faust2pd rely on this.)

  You can also specify just a part of the control path (like
  <verbatim|bar/foo> or just <verbatim|foo> in the example above) which means
  that the message applies to <em|all> controls which have the given pathname
  as the final portion of their fully qualified name. Thus, if there is more
  than one <verbatim|foo> control in different groups of the Faust unit then
  sending the message <verbatim|foo> to the control inlet will report the
  fully qualified name and value for each of them. Likewise, sending
  <verbatim|foo> <verbatim|0.99> will set the value of all controls named
  <verbatim|foo> at once.

  Concerning the naming of Faust controls in Pd you should also note the
  following:

  <\itemize>
    <item>A unit name can be specified at object creation time, in which case
    the given symbol is used as a prefix for all control names of the unit.
    E.g., the control <verbatim|/gnu/bar/foo> of an object <verbatim|baz~>
    created with <verbatim|baz~> <verbatim|baz1> has the fully qualified name
    <verbatim|/baz1/gnu/bar/foo>. This lets you distinguish different
    instances of an object such as, e.g., different voices of a polyphonic
    synth unit.

    <item>Pd's input syntax for symbols is rather restrictive. Therefore
    group and control names in the Faust source are mangled into a form which
    only contains alphanumeric characters and hyphens, so that the control
    names are always legal Pd symbols. For instance, a Faust control name
    like <verbatim|meter> <verbatim|<1>> <verbatim|(dB)> will become
    <verbatim|meter-1-dB> which can be input directly as a symbol in Pd
    without any problems.

    <item>``Anonymous'' groups and controls (groups and controls which have
    empty labels in the Faust source) are omitted from the path
    specification. E.g., if <verbatim|foo> is a control located in a main
    group with an empty name then the fully qualified name of the control is
    just <verbatim|/foo> rather than <verbatim|//foo>. Likewise, an anonymous
    control in the group <verbatim|/foo/bar> is named just
    <verbatim|/foo/bar> instead of <verbatim|/foo/bar/>.
  </itemize>

  Last but not least, there is also a special control named <verbatim|active>
  which is generated automatically for your convenience. The default
  behaviour of this control is as follows:

  <\itemize>
    <item>When <verbatim|active> is nonzero (the default), the unit works as
    usual.

    <item>When <verbatim|active> is zero, and the unit's number of audio
    inputs and outputs match, then the audio input is simply passed through.

    <item>When <verbatim|active> is zero, but the unit's number of audio
    inputs and outputs do <em|not> match, then the unit generates silence.
  </itemize>

  The <verbatim|active> control frequently alleviates the need for special
  ``bypass'' or ``mute'' controls in the Faust source. However, if the
  default behaviour of the generated control is not appropriate you can also
  define your own custom version of <verbatim|active> explicitly in the Faust
  program; in this case the custom version will override the default one.

  <subsection|Examples<label|examples>>

  In the examples subdirectory you'll find a bunch of sample Faust DSPs and
  Pd patches illustrating how Faust units are used in Pd.

  <\itemize>
    <item>The examples/basic/test.pd patch demonstrates the basics of
    operating ``bare'' Faust plugins in Pd. You'll rarely have to do this
    when using the wrappers generated with the faust2pd program, but it is a
    useful starting point to take a look behind the scenes anyway.

    <item>The examples/faust directory contains all the examples from (an
    earlier version of) the Faust distribution, along with corresponding Pd
    wrappers generated with faust2pd. Have a look at
    examples/faust/faustdemo.pd to see some of the DSPs in action. Note that
    not all examples from the Faust distribution are working out of the box
    because of name clashes with Pd builtins, so we renamed those. We also
    edited some of the .dsp sources (e.g., turning buttons into checkboxes or
    sliders into nentries) where this seemed necessary to make it easier to
    operate the Pd patches.

    <item>The examples/synth directory contains various plugins and patches
    showing how to implement polyphonic synthesizers using Faust units. Take
    a look at examples/synth/synth.pd for an example. If you have properly
    configured your interfaces then you should be able to play the
    synthesizer via Pd's MIDI input.

    <item>The examples/seqdemo/seqdemo.pd patch demonstrates how to operate a
    multitimbral synth, built with Faust units, in an automatic fashion using
    a pattern sequencer programmed in Pure. This example requires the Pure
    interpreter as well as the pd-pure plugin available from
    <hlink|http://purelang.bitbucket.org|http://purelang.bitbucket.org>.
  </itemize>

  <subsection|Wrapping DSPs with faust2pd<label|wrapping-dsps-with-faust2pd>>

  The faust2pd script generates Pd patches from the dsp.xml files created by
  Faust when run with the -xml option. Most of the sample patches were
  actually created that way. After installation you can run the script as
  follows:

  <\verbatim>
    faust2pd [-hVbs] [-f size] [-o output-file] [-n #voices]

    \ \ [-r max] [-X patterns] [-x width] [-y height] input-file
  </verbatim>

  The default output filename is <verbatim|input-file> with new extension
  <verbatim|.pd>. Thus, <verbatim|faust2pd> <verbatim|filename.dsp.xml>
  creates a Pd patch named <verbatim|filename.pd> from the Faust XML
  description in <verbatim|filename.dsp.xml>.

  The faust2pd program understands a number of options which affect the
  layout of the GUI elements and the contents of the generated patch. Here is
  a brief list of the available options:

  -h, --help display a short help message and exit -V, --version display the
  version number and exit -b, --fake-buttons <nbsp> replace buttons (bangs)
  with checkboxes (toggles) -f, --font-size <nbsp> font size for GUI elements
  (10 by default) -n, --nvoices create a synth patch with the given number of
  voices -o, --output-file <nbsp> output file name (.pd file) -r,
  --radio-sliders <nbsp> radio controls for sliders -s, --slider-nums <nbsp>
  sliders with additional number control -X, --exclude exclude controls
  matching the given glob patterns -x, --width maximum width of the GUI area
  -y, --height maximum height of the GUI area Just like the Faust plugin
  itself, the generated patch has a control input/output as the leftmost
  inlet/outlet pair, and the remaining plugs are signal inlets and outlets
  for each audio input/output of the Faust unit. However, the control
  inlet/outlet pair works slightly different from that of the Faust plugin.
  Instead of being used for control replies, the control outlet of the patch
  simply passes through its control input (after processing messages which
  are understood by the wrapped plugin). By these means control messages can
  flow along with the audio signal through an entire chain of Faust units.
  (You can find an example of this in examples/faust/faustdemo.pd.) Moreover,
  when generating a polyphonic synth patch using the -n option then there
  will actually be two control inlets, one for note messages and one for
  ordinary control messages; this is illustrated in the
  examples/synth/synth.pd example.

  The generated patch also includes the necessary GUI elements to see and
  change all (active and passive) controls of the Faust unit. Faust control
  elements are mapped to Pd GUI elements in an obvious fashion, following the
  horizontal and vertical layout specified in the Faust source. The script
  also adds special buttons for resetting all controls to their defaults and
  to operate the special <verbatim|active> control.

  This generally works very well, but you should be aware that the control
  GUIs generated by faust2pd are somewhat hampered by the limited range of
  GUI elements available in a vanilla Pd installation. As a remedy, faust2pd
  provides various options to change the content of the generated wrapper and
  work around these limitations.

  <\itemize>
    <item>There are no real button widgets as required by the Faust
    specification, so bangs are used instead. There is a global delay time
    for switching the control from 1 back to 0, which can be changed by
    sending a value in milliseconds to the <verbatim|faust-delay> receiver.
    If you need interactive control over the switching time then it is better
    to use checkboxes instead, or you can have faust2pd automatically
    substitute checkboxes for all buttons in a patch by invoking it with the
    -b a.k.a. \Ufake-buttons option.

    <item>Sliders in Pd do not display their value in numeric form so it may
    be hard to figure out what the current value is. Therefore faust2pd has
    an option -s a.k.a. \Uslider-nums which causes it to add a number box to
    each slider control. (This flag also applies to Faust's passive bargraph
    controls, as these are implemented using sliders, see below.)

    <item>Pd's sliders also have no provision for specifying a stepsize, so
    they are an awkward way to input integral values from a small range.
    OTOH, Faust doesn't support the ``radio'' control elements which Pd
    provides for that purpose. As a remedy, faust2pd allows you to specify
    the option -r max (a.k.a. \Uradio-sliders=max) to indicate that sliders
    with integral values from the range 0..max-1 are to be mapped to
    corresponding Pd radio controls.

    <item>Faust's bargraphs are emulated using sliders. Note that these are
    passive controls which just display a value computed by the Faust unit. A
    different background color is used for these widgets so that you can
    distinguish them from the ordinary (active) slider controls. The values
    shown in passive controls are sampled every 40 ms by default. You can
    change this value by sending an appropriate message to the global
    <verbatim|faust-timer> receiver.

    <item>Since Pd has no ``tabbed'' (notebook-like) GUI element, Faust's
    tgroups are mapped to hgroups instead. It may be difficult to present
    large and complicated control interfaces without tabbed dialogs, though.
    As a remedy, you can control the amount of horizontal or vertical space
    available for the GUI area with the -x and -y (a.k.a. \Uwidth and
    \Uheight) options and faust2pd will then try to break rows and columns in
    the layout to make everything fit within that area. (This feature has
    only been tested with simple layouts so far, so beware.)

    <item>You can also exclude certain controls from appearing in the GUI
    using the -X option. This option takes a comma-separated list of shell
    glob patterns indicating either just the names or the fully qualified
    paths of Faust controls which are to be excluded from the GUI. For
    instance, the option <verbatim|-X> <verbatim|'volume,meter*,faust/resonator?/*'>
    will exclude all volume controls, all controls whose names start with
    <verbatim|meter>, and all controls in groups matching
    <verbatim|faust/resonator?>. (Note that the argument to -X has to be
    quoted if it contains any wildcards such as <verbatim|*> and
    <verbatim|?>, so that the shell doesn't try to expand the patterns
    beforehand. Also note that only one -X option is recognized, so you have
    to specify all controls to be excluded as a single option.)

    <item>Faust group labels are not shown at all, since I haven't found an
    easy way to draw some kind of labelled frame in Pd yet.
  </itemize>

  Despite these limitations, faust2pd appears to work rather well, at least
  for the kind of DSPs found in the Faust distribution. (Still, for more
  complicated control surfaces and interfaces to be used on stage you'll
  probably have to edit the generated GUI layouts by hand.)

  For convenience, all the content-related command line options mentioned
  above can also be specified in the Faust source, as special tags in the
  label of the toplevel group of the dsp. These take the form
  <verbatim|[pd:option]> or <verbatim|[pd:option=value]> where
  <verbatim|option> is any of the (long) options understood by faust2pd. For
  instance:

  <\verbatim>
    process = vgroup("mysynth [pd:nvoices=8] [pd:slider-nums]", ...);
  </verbatim>

  Source options carrying arguments, like <verbatim|nvoices> in the above
  example, can also be overridden with corresponding command line options.

  <subsection|Conclusion<label|conclusion>>

  Creating Faust plugins for use with Pd has never been easier before, so I
  hope that you'll soon have much joy trying your Faust programs in Pd. Add
  Pd-Pure to this, and you can program all your specialized audio and control
  objects using two modern-style functional languages which are much more fun
  than C/C++. Of course there's an initial learning curve to be mastered, but
  IMHO it is well worth the effort. The bottomline is that Pd+Faust+Pure
  really makes an excellent combo which provides you with a powerful,
  programmable interactive environment for creating advanced computer music
  and multimedia applications with ease.

  <subsubsection|Acknowledgements<label|acknowledgements>>

  Thanks are due to Yann Orlarey for his wonderful Faust, which makes
  developing DSP algorithms so easy and fun.

  <label|module-faustxml><subsection|Appendix:
  faustxml<label|appendix-faustxml>>

  The faustxml module is provided along with faust2pd to retrieve the
  description of a Faust DSP from its XML file as a data structure which is
  ready to be processed by Pure programs. It may also be useful in other Pure
  applications which need to inspect descriptions of Faust DSPs.

  The main entry point is the <hlink|<with|font-family|tt|info>|#faustxml::info>
  function which takes the name of a Faust-generated XML file as argument and
  returns a tuple <verbatim|(name,> <verbatim|descr,> <verbatim|version,>
  <verbatim|in,> <verbatim|out,> <verbatim|controls)> with the name,
  description, version, number of inputs and outputs and the toplevel group
  with the descriptions of the controls of the dsp. A couple of other
  convenience functions are provided to deal with the control descriptions.

  <subsubsection|Usage<label|usage>>

  Use the following declaration to import this module in your programs:

  <\verbatim>
    using faustxml;
  </verbatim>

  For convenience, you can also use the following to get access to the
  module's namespace:

  <\verbatim>
    using namespace faustxml;
  </verbatim>

  <subsubsection|Data Structure<label|data-structure>>

  The following constructors are used to represent the UI controls of Faust
  DSPs:

  <\description>
    <item*|<em|constructor> faustxml::button label<label|faustxml::button>>

    <item*|<em|constructor> faustxml::checkbox
    label<label|faustxml::checkbox>>A button or checkbox with the given
    label.
  </description>

  <\description>
    <item*|<em|constructor> faustxml::nentry
    (label,init,min,max,step)<label|faustxml::nentry>>

    <item*|<em|constructor> faustxml::vslider
    (label,init,min,max,step)<label|faustxml::vslider>>

    <item*|<em|constructor> faustxml::hslider
    (label,init,min,max,step)<label|faustxml::hslider>>A numeric input
    control with the given label, initial value, range and stepwidth.
  </description>

  <\description>
    <item*|<em|constructor> faustxml::vbargraph
    (label,min,max)<label|faustxml::vbargraph>>

    <item*|<em|constructor> faustxml::hbargraph
    (label,min,max)<label|faustxml::hbargraph>>A numeric output control with
    the given label and range.
  </description>

  <\description>
    <item*|<em|constructor> faustxml::vgroup
    (label,controls)<label|faustxml::vgroup>>

    <item*|<em|constructor> faustxml::hgroup
    (label,controls)<label|faustxml::hgroup>>

    <item*|<em|constructor> faustxml::tgroup
    (label,controls)<label|faustxml::tgroup>>A group with the given label and
    list of controls in the group.
  </description>

  <subsubsection|Operations<label|operations>>

  <\description>
    <item*|faustxml::controlp x<label|faustxml::controlp>>Check for control
    description values.
  </description>

  <\description>
    <item*|faustxml::control_type x<label|faustxml::control-type>>

    <item*|faustxml::control_label x<label|faustxml::control-label>>

    <item*|faustxml::control_args x<label|faustxml::control-args>>Access
    functions for the various components of a control description.
  </description>

  <\description>
    <item*|faustxml::controls x<label|faustxml::controls>>This function
    returns a flat representation of a control group <verbatim|x> as a list
    of basic control descriptions, which provides a quick way to access all
    the control values of a Faust DSP. The grouping controls themselves are
    omitted. You can pass the last component of the return value of the
    <hlink|<with|font-family|tt|info>|#faustxml::info> function to this
    function.
  </description>

  <\description>
    <item*|faustxml::pcontrols x<label|faustxml::pcontrols>>Works like the
    <hlink|<with|font-family|tt|controls>|#faustxml::controls> function
    above, but also replaces the label of each basic control with a fully
    qualified path consisting of all control labels leading up to the given
    control. Thus, e.g., the label of a slider <verbatim|"gain"> inside a
    group <verbatim|"voice#0"> inside the main <verbatim|"faust"> group will
    be denoted by the label <verbatim|"faust/voice#0/gain">.
  </description>

  <\description>
    <item*|faustxml::info fname<label|faustxml::info>>Extract the description
    of a Faust DSP from its XML file. This is the main entry point. Returns a
    tuple with the name, description and version of the DSP, as well as the
    number of inputs and outputs and the toplevel group with all the control
    descriptions. Raises an exception if the XML file doesn't exist or
    contains invalid contents.
  </description>

  Example:

  <\verbatim>
    \<gtr\> using faustxml;

    \<gtr\> let name,descr,version,in,out,group =

    \<gtr\> \ \ faustxml::info "examples/basic/freeverb.dsp.xml";

    \<gtr\> name,descr,version,in,out;

    "freeverb","freeverb -- a Schroeder reverb","1.0",2,2

    \<gtr\> using system;

    \<gtr\> do (puts.str) $ faustxml::pcontrols group;

    faustxml::hslider ("freeverb/damp",0.5,0.0,1.0,0.025)

    faustxml::hslider ("freeverb/roomsize",0.5,0.0,1.0,0.025)

    faustxml::hslider ("freeverb/wet",0.3333,0.0,1.0,0.025)
  </verbatim>

  <subsubsection*|<hlink|Table Of Contents|index.tm><label|faust2pd-toc>>

  <\itemize>
    <item><hlink|faust2pd: Pd Patch Generator for Faust|#>

    <\itemize>
      <item><hlink|Copying|#copying>

      <item><hlink|Requirements|#requirements>

      <item><hlink|Installation|#installation>

      <item><hlink|Quickstart|#quickstart>

      <item><hlink|Control Interface|#control-interface>

      <item><hlink|Examples|#examples>

      <item><hlink|Wrapping DSPs with faust2pd|#wrapping-dsps-with-faust2pd>

      <item><hlink|Conclusion|#conclusion>

      <\itemize>
        <item><hlink|Acknowledgements|#acknowledgements>
      </itemize>

      <item><hlink|Appendix: faustxml|#appendix-faustxml>

      <\itemize>
        <item><hlink|Usage|#usage>

        <item><hlink|Data Structure|#data-structure>

        <item><hlink|Operations|#operations>
      </itemize>
    </itemize>
  </itemize>

  Previous topic

  <hlink|pure-tk|pure-tk.tm>

  Next topic

  <hlink|pd-faust|pd-faust.tm>

  <hlink|toc|#faust2pd-toc> <hlink|index|genindex.tm>
  <hlink|modules|pure-modindex.tm> \| <hlink|next|pd-faust.tm> \|
  <hlink|previous|pure-tk.tm> \| <hlink|Pure Language and Library
  Documentation|index.tm>

  <copyright> Copyright 2009-2014, Albert Gr�f et al. Last updated on Oct
  22, 2014. Created using <hlink|Sphinx|http://sphinx.pocoo.org/> 1.1.3.
</body>
