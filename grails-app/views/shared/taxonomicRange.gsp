<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="min" />
        <title><g:message code="collection.base.label" default="Edit taxonomy hints" /></title>
        %{--<link rel="stylesheet" href="${resource(dir:'css/smoothness',file:'jquery-ui-1.8.14.custom.css')}" type="text/css" media="screen"/>
        <g:javascript library="jquery-ui-1.8.14.custom.min"/>--}%
        <g:javascript library="jquery.jstree"/>
        <g:javascript library="jquery.tools.min"/>
        <g:javascript library="debug"/>
    </head>
    <body>
        <div class="title-bar">
            <h1><span class="label">Editing: </span>${command.name}</h1>
        </div>
        <div id="baseForm" class="body">
            <g:if test="${message}">
            <div class="message">${message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="baseForm" action="base">
                <g:hiddenField name="id" value="${command?.id}" />
                <g:hiddenField name="version" value="${command.version}" />
                <g:hiddenField name="range" value="${command.listTaxonomicRange() ? command.listTaxonomicRange().join(',') : ''}" />
                <div class="dialog">
                  <h2>Describe the taxonomic range of this resource.</h2>
                  <p>Select any number of the groups listed below. The right-hand box shows a consolidated list of your selections.</p>
                  %{--<p class="potential-problem">Note that IE<span> </span>&nbsp;has some minor problems with the list below. Nodes in the list will not close. You are still able to use the list to define your taxonomic scope.</p>--}%
                  <div class="float-widget-container" id="selections">
                  <h3>Make your selections here</h3>
                  <div><button type="button" id="clear">clear all</button> </div>
                    %{--<div>
                      <h4>Choose a taxonomic rank and name</h4>
                      <input class="selector" id="rank"/> =
                      <input class="selector" id="name"/>
                      <button id="addSci" type="button">Add</button>
                    </div>--}%
                  <div>
                    <h4>Browse and select</h4>
                    <div id="fauna-tree"></div>
                  </div>
                </div>

                  <div class="float-widget-container" id="selected-list">
                    <h3>Selected groups</h3>
                    <ul></ul>
                  </div>

                  <div style="clear: both;"></div>

                </div>

                <div class="buttons">
                    <span class="button"><input type="submit" name="_action_updateTaxonomicRange" value="Update" class="save"></span>
                    <span class="button"><input type="submit" name="_action_cancel" value="Cancel" class="cancel"></span>
                </div>
            </g:form>
        </div>
        <div class="simple_overlay" id="help">
          <div class="details">
            <h2>Some help pages</h2>
            <p><a href="#">How do I select taxonomic groups?</a></p>
            <p><a href="#">How do I save my selections?</a></p>
            <p><a href="#">How do I define a taxonomic scope?</a></p>
            <p><a href="#">How do I change the metadata for a data resource?</a></p>
            <h2>Some relevant FAQs</h2>
            <p><a href="#">What if my taxonomic group isn't shown here?</a></p>
            <p><a href="#">Who chose this set of taxonomic groups?</a></p>
            <p><a href="#">What is this information used for?</a></p>
            <p><a href="#">How do I report a bug?</a></p>
          </div>
        </div>

    <script type="text/javascript">
      var baseUrl = "${ConfigurationHolder.config.grails.serverURL}";

      //var sampleJson = {"data":"Fauna","attr":{"id":"Fauna"},"state":"open","children":[{"data":"Lower Invertebrates","attr":{"id":"Lower_Invertebrates"},"state":"open","children":[{"data":"Porifera (Sponges)","attr":{"id":"Porifera"}},{"data":"Cestoda (Tapeworms)","attr":{"id":"Cestoda"}},{"data":"Nemertea (Nemertine worms, ribbon worms)","attr":{"id":"Nemertea"}},{"data":"Nematoda (Nematodes, roundworms)","attr":{"id":"Nematoda"}},{"data":"Kamptozoa (Entoprocts)","attr":{"id":"Kamptozoa"}}]},{"data":"Higher Invertebrates","attr":{"id":"Higher_Invertebrates"},"state":"open","children":[{"data":"Chaetognatha (Arrow worms)","attr":{"id":"Chaetognatha"}},{"data":"Brachiopoda (Lamp shells)","attr":{"id":"Brachiopoda"}},{"data":"Mollusca (Snails, bivalves, squid, chitons)","attr":{"id":"Mollusca"},"children":[{"data":"Aplacophora (Aplacophorans)","attr":{"id":"Aplacophora"}},{"data":"Polyplacophora (Chitons)","attr":{"id":"Polyplacophora"}},{"data":"Cephalopoda (Squid, octopus, ammonites)","attr":{"id":"Cephalopoda"}},{"data":"Scaphopoda (Tusk shells, tooth shells)","attr":{"id":"Scaphopoda"}},{"data":"Bivalvia (Bivalves, clams, cockles)","attr":{"id":"Bivalvia"}},{"data":"Gastropoda (snails)","attr":{"id":"Gastropoda"}},{"data":"Pulmonata (pulmonate snails)","attr":{"id":"Pulmonata"}}]},{"data":"Sipuncula (Peanut worms)","attr":{"id":"Sipuncula"}},{"data":"Echiura (Spoon worms)","attr":{"id":"Echiura"}},{"data":"Annelida (Fan worms, earthworms, leeches)","attr":{"id":"Annelida"},"children":[{"data":"Polychaeta (sand, tube and fan worms)","attr":{"id":"Polychaeta"}},{"data":"Oligochaeta (earthworms, enchytraeids, microdriles)","attr":{"id":"Oligochaeta"}},{"data":"Hirudinea (leeches)","attr":{"id":"Hirudinea"}}]},{"data":"Onychophora (Velvet worms)","attr":{"id":"Onychophora"}},{"data":"Arthropoda (Crabs, prawns, slaters, insects, spiders, mites)","attr":{"id":"Arthropoda"},"children":[{"data":"Crustacea (Crabs, prawns, lobsters, shrimps)","attr":{"id":"Crustacea"},"children":[{"data":"Branchiopoda (Fairy, clam and shield shrimps, water fleas)","attr":{"id":"Branchiopoda"}},{"data":"Ostracoda (Ostracods, seed or mussel shrimps)","attr":{"id":"Ostracoda"}},{"data":"Copepoda (Copepods)","attr":{"id":"Copepoda"}},{"data":"Decapoda (Crabs, prawns, lobsters, yabbies, marron)","attr":{"id":"Decapoda"}},{"data":"Syncarida (Anaspidaceans)","attr":{"id":"Syncarida"}},{"data":"Peracarida (Amphipods, isopods, krill, slaters)","attr":{"id":"Peracarida"}}]},{"data":"Arachnida (Spiders, mites, ticks, scorpions)","attr":{"id":"Arachnida"},"children":[{"data":"Schizomida (Whip scorpions)","attr":{"id":"Schizomida"}},{"data":"Amblypygi (Tail-less whip-scorpions)","attr":{"id":"Amblypygi"}},{"data":"Palpigradi (Palpigrades)","attr":{"id":"Palpigradi"}},{"data":"Pseudoscorpiones (False scorpions)","attr":{"id":"Pseudoscorpiones"}},{"data":"Scorpiones (Scorpions)","attr":{"id":"Scorpiones"}},{"data":"Acarina (Mites, ticks)","attr":{"id":"Acarina"}},{"data":"Opiliones (Harvestmen, daddy longlegs)","attr":{"id":"Opiliones"}},{"data":"Araneae (Spiders)","attr":{"id":"Araneae"}},{"data":"Pycnogonida (Sea spiders)","attr":{"id":"Pycnogonida"}}]},{"data":"Symphyla (Symphylans)","attr":{"id":"Symphyla"}},{"data":"Chilopoda (Centipedes, scutigeromorphs)","attr":{"id":"Chilopoda"}},{"data":"Diplopoda (Millipedes)","attr":{"id":"Diplopoda"}},{"data":"Pauropoda (Pauropods)","attr":{"id":"Pauropoda"}},{"data":"Protura (Proturans)","attr":{"id":"Protura"}},{"data":"Collembola (Springtails)","attr":{"id":"Collembola"}},{"data":"Diplura (Diplurans)","attr":{"id":"Diplura"}},{"data":"Insecta (Insects)","attr":{"id":"Insecta"},"children":[{"data":"Zygentoma (Silverfish, bristletails)","attr":{"id":"Zygentoma"}},{"data":"Archaeognatha (Archaeognaths)","attr":{"id":"Archaeognatha"}},{"data":"Ephemeroptera (Mayflies)","attr":{"id":"Ephemeroptera"}},{"data":"Odonata (Dragonflies, damselflies)","attr":{"id":"Odonata"}},{"data":"Blattodea (Cockroaches)","attr":{"id":"Blattodea"}},{"data":"Mantodea (Mantids, praying mantids)","attr":{"id":"Mantodea"}},{"data":"Isoptera (Termites)","attr":{"id":"Isoptera"}},{"data":"Plecoptera (Stoneflies)","attr":{"id":"Plecoptera"}},{"data":"Orthoptera (Locusts, grasshoppers, crickets)","attr":{"id":"Orthoptera"}},{"data":"Dermaptera (Earwigs)","attr":{"id":"Dermaptera"}},{"data":"Embioptera (Web-spinners)","attr":{"id":"Embioptera"}},{"data":"Phasmatodea (Stick insects)","attr":{"id":"Phasmatodea"}},{"data":"Zoraptera (Zorapterans)","attr":{"id":"Zoraptera"}},{"data":"Psocoptera (Psocids, barklice, booklice)","attr":{"id":"Psocoptera"}},{"data":"Phthiraptera (Lice)","attr":{"id":"Phthiraptera"}},{"data":"Heteroptera (Bugs)","attr":{"id":"Heteroptera"}},{"data":"Thysanoptera (Thrips)","attr":{"id":"Thysanoptera"}},{"data":"Aleyrodoidea (Whiteflies)","attr":{"id":"Aleyrodoidea"}},{"data":"Aphidoidea (Aphids, greenflies)","attr":{"id":"Aphidoidea"}},{"data":"Coccoidea (Scale insects, mealy bugs)","attr":{"id":"Coccoidea"}},{"data":"Psylloidea (Psyllids, jumping plantlice)","attr":{"id":"Psylloidea"}},{"data":"Cicadoidea (Cicadas)","attr":{"id":"Cicadoidea"}},{"data":"Auchenorrhyncha (leaf-hoppers, plant hoppers, spittle bugs)","attr":{"id":"Auchenorrhyncha"}},{"data":"Strepsiptera (Stylops)","attr":{"id":"Strepsiptera"}},{"data":"Coleoptera (Beetles)","attr":{"id":"Coleoptera"},"children":[{"data":"Archostemata (Ommatids, Cupedids)","attr":{"id":"Archostemata"}},{"data":"Myxophaga (Microsporids)","attr":{"id":"Myxophaga"}},{"data":"Adephaga (Ground Beetles, Water Beetles)","attr":{"id":"Adephaga"}},{"data":"Hydrophiloidea (Hydrophilids, Histerids)","attr":{"id":"Hydrophiloidea"}},{"data":"Staphylinoidea (Feather-wing Beetles, Carrion Beetles, Burying Beetles, Ant-like Litter Beetles)","attr":{"id":"Staphylinoidea"}},{"data":"Scirtoidea (Scirtids, Clambids)","attr":{"id":"Scirtoidea"}},{"data":"Scarabaeoidea (Dung Beetles, Christmas Beetles)","attr":{"id":"Scarabaeoidea"}},{"data":"Dascilloidea (Dascillids, Rhipicerids)","attr":{"id":"Dascilloidea"}},{"data":"Byrrhoidea (Byrrhids, Elmids)","attr":{"id":"Byrrhoidea"}},{"data":"Elateroidea (Click Beetles)","attr":{"id":"Elateroidea"}},{"data":"Buprestoidea (Jewel Beetles)","attr":{"id":"Buprestoidea"}},{"data":"Bostrichoidea (Dermestids)","attr":{"id":"Bostrichoidea"}},{"data":"Lymexyloidea (Lymexylids)","attr":{"id":"Lymexyloidea"}},{"data":"Cucujoidea (Flower, Flat Bark and Ladybird Beetles)","attr":{"id":"Cucujoidea"}},{"data":"Tenebrionoidea (Tenebrionids)","attr":{"id":"Tenebrionoidea"}},{"data":"Chrysomeloidea (Leaf-eating beetles)","attr":{"id":"Chrysomeloidea"}}]},{"data":"Neuroptera (Lacewings, ant lions)","attr":{"id":"Neuroptera"}},{"data":"Megaloptera (Alderflies, dobsonflies)","attr":{"id":"Megaloptera"}},{"data":"Hymenoptera (Wasps, sawflies, ants, bees)","attr":{"id":"Hymenoptera"},"children":[{"data":"Symphyta (Sawflies)","attr":{"id":"Symphyta"}},{"data":"Stephanoidea (Parasitic wasps)","attr":{"id":"Stephanoidea"}},{"data":"Megalyroidea (Parasitic wasps)","attr":{"id":"Megalyroidea"}},{"data":"Trigonaloidea (Parasitic wasps)","attr":{"id":"Trigonaloidea"}},{"data":"Evanoidea (Parasitic wasps)","attr":{"id":"Evanoidea"}},{"data":"Proctotrupoidea (Parasitic wasps)","attr":{"id":"Proctotrupoidea"}},{"data":"Platygastroidea (Parasitic wasps)","attr":{"id":"Platygastroidea"}},{"data":"Chalcidoidea (Parasitic wasps)","attr":{"id":"Chalcidoidea"}},{"data":"Mymarommatoidea (Parasitic wasps)","attr":{"id":"Mymarommatoidea"}},{"data":"Ichneumonoidea (Parasitic wasps)","attr":{"id":"Ichneumonoidea"}},{"data":"Chrysidoidea (Parasitic wasps)","attr":{"id":"Chrysidoidea"}},{"data":"Vespoidea (Ants, spider wasps, flower wasps)","attr":{"id":"Vespoidea"}},{"data":"Apoidea (Bees, sphecids)","attr":{"id":"Apoidea"}}]},{"data":"Mecoptera (Scorpionflies)","attr":{"id":"Mecoptera"}},{"data":"Siphonaptera (Fleas)","attr":{"id":"Siphonaptera"}},{"data":"Diptera (Flies)","attr":{"id":"Diptera"},"children":[{"data":"Nematocera (Lower Flies)","attr":{"id":"Nematocera"}},{"data":"Orthorrhapha (March, Horse, Long-legged, Bee Flies)","attr":{"id":"Orthorrhapha"}},{"data":"Cyclorrhapha (Fruit Flies, Signal Flies, Vinegar Flies)","attr":{"id":"Cyclorrhapha"}}]},{"data":"Trichoptera (Caddisflies)","attr":{"id":"Trichoptera"}},{"data":"Lepidoptera (Butterflies, moths)","attr":{"id":"Lepidoptera"},"children":[{"data":"Incurvarioidea (Ghost, leaf miner and fairy moths)","attr":{"id":"Incurvarioidea"}},{"data":"Noctuoidea (Cut worms, army worms, bud worms)","attr":{"id":"Noctuoidea"}},{"data":"Castnioidea (sun moths)","attr":{"id":"Castnioidea"}},{"data":"Gelechioidea (Litter moths)","attr":{"id":"Gelechioidea"}},{"data":"Zygaenoidea (Burnets, foresters)","attr":{"id":"Zygaenoidea"}},{"data":"Hesperioidea (Skippers)","attr":{"id":"Hesperioidea"}},{"data":"Papilionoidea (Butterflies)","attr":{"id":"Papilionoidea"}}]}]}]},{"data":"Echinodermata (Starfish, sea urchins, sea cucumbers, brittle stars)","attr":{"id":"Echinodermata"}},{"data":"Hemichordata (Acorn worms)","attr":{"id":"Hemichordata"}}]},{"data":"Chordata","attr":{"id":"Chordata"},"state":"open","children":[{"data":"Tunicata (Sea squirts, ascidians)","attr":{"id":"Tunicata"}},{"data":"Cephalochordata (Lancelets, amphioxus)","attr":{"id":"Cephalochordata"}},{"data":"Pisces (Fish, sharks, rays)","attr":{"id":"Pisces"},"children":[{"data":"Myxini (Hagfishes)","attr":{"id":"Myxini"}},{"data":"Petromyzontida (Lampreys)","attr":{"id":"Petromyzontida"}},{"data":"Chondrichthyes (Sharks, Rays, Chimaeras)","attr":{"id":"Chondrichthyes"}},{"data":"Sarcopterygii (Lungfish)","attr":{"id":"Sarcopterygii"}},{"data":"Actinopterygii (Ray-finned fishes)","attr":{"id":"Actinopterygii"},"children":[{"data":"Osteoglossomorpha (Saratoga)","attr":{"id":"Osteoglossomorpha"}},{"data":"Elopomorpha (Eels, Oxeye herrings, Halosaurs)","attr":{"id":"Elopomorpha"}},{"data":"Clupeomorpha (Anchovies, Sardines)","attr":{"id":"Clupeomorpha"}},{"data":"Euteleostei (All other fishes)","attr":{"id":"Euteleostei"}}]}]},{"data":"Amphibia (Frogs)","attr":{"id":"Amphibia"}},{"data":"Reptilia (Reptiles)","attr":{"id":"Reptilia"}},{"data":"Aves (Birds)","attr":{"id":"Aves"}},{"data":"Mammalia (Mammals)","attr":{"id":"Mammalia"},"children":[{"data":"Prototheria (Echidna, platypus)","attr":{"id":"Prototheria"}},{"data":"Marsupialia (Marsupials)","attr":{"id":"Marsupialia"}},{"data":"Eutheria (Placental mammals)","attr":{"id":"Eutheria"}}]}]}]};
      function init() {
        /*// rank autocomplete
        $("#rank").autocomplete({
          source: ["kingdom","subkingdom","division or phylum","subdivision or subphylum","class","subclass","order","suborder","family","subfamily","tribe","subtribe","genus","subgenus","section","subsection","series","subseries","species","subspecies","variety","subvariety","form","subform"],
          minLength: 0,
          select: function(event, ui) {
            $('#name').focus();
          }
        });
        // add rank-name
        $('#addSci').click(function() {
          $('#selected-list ul').append('<li>' + $('#rank').val() + ': ' + $('#name').val() + '</li>');
        });*/
        // add fauna tree
        $('#fauna-tree').jstree({
          json_data: {
            /*data: sampleJson*/
            ajax: {
              url: baseUrl + "/data/taxa.json"
              //url: baseUrl + "/data/taxa-groups.json"
            }
          },
          core: { animation: 400, open_parents: true },
          themes:{
            theme: 'classic',
            icons: false
          },
          checkbox: {override_ui:true},
          plugins: ['json_data','themes','checkbox','ui']
        });
        // set initial state when tree has loaded
        $('#fauna-tree').bind('loaded.jstree', function() {
          var range = $('input#range').val();
          if (range != '') {
            var list = range.split(',');
            $.each(list, function(i,value) {
//              alert('checking ' + value + ': exists? ' + $('li#' + value).length);
              var hit = $('li#' + value);
              if (hit) {
                $('#fauna-tree').jstree('change_state', hit);
                // open the node
                if (hit.hasClass('jstree-leaf')) {
                  // open the parent
                  $('#fauna-tree').jstree('open_node', hit.parentsUntil('li'));
                }
                else {
                  $('#fauna-tree').jstree('open_node', hit);
                }
              }
            });
            if (jQuery.browser.msie) {
              var version = parseInt(jQuery.browser.version,10);
              if (version === 9 || version === 8 || version === 7) {
                $('#fauna-tree').jstree('open_all', -1, false);
              }
            }
            updateList();
          }
          // update on check
          $('#fauna-tree').bind('check_node.jstree',function(event, data){
            updateList();
          });
          // update on un-check
          $('#fauna-tree').bind('uncheck_node.jstree',function(event, data){
            updateList();
          });
        });
        // clear all
        $('#clear').click(function() {
          $('input#range').val('');
          $('#fauna-tree').jstree('uncheck_node', 'li');
        });
        // init help link
        $('a#helpLink').overlay();
        // flag possible problem in IE 7, 8, 9
        /*if (jQuery.browser.msie) {
          var version = parseInt(jQuery.browser.version,10);
          if (version === 9 || version === 8 || version === 7) {
            $('.potential-problem span').html(" " + version);
            $('.potential-problem').css('display','block');
            // open all nodes so it is at least consistent
          }
        }*/
      }
      function updateList() {
        $('#selected-list li').remove();
        $('input#range').val('');
        var $checked = $('#fauna-tree').jstree('get_checked');
        $.each($checked, function(i, obj) {
          addItem($(obj).attr('rank'),$(obj).attr('id'));
        })
      }
      function addItem(rank, name) {
        //var text = rank == undefined || rank == 'group' ? name : name + " (" + rank + ")";
        var text = name;
        var $item = $('<li></li>').appendTo('#selected-list ul');
        $item.append(text);
        // add to hidden field
        var str = $('input#range').val();
        str += name + ',';
        $('input#range').val(str);
      }
      $(function(){
        init();
      })
    </script>
    </body>
</html>
