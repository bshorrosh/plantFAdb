root = TreeNode.create name: 'Plantae', common_name: '', note: ''

seed_plants = root.children.create name: 'Spermatophyte', common_name: 'Seed Plants', note: 'Seed Plants' 

gmyno = seed_plants.children.create name: 'Gymnosperms', common_name: '', note: ''
  gmyno.children.create name: 'Cycadales', common_name: 'Palm', note: 'Cycads w. stout, woody trunk, evergreen leaves'
  gmyno.children.create name: 'Ginkgoales', common_name: 'Ginkgo', note: 'only one extant species: Ginkgo biloba, the ginkgo tree'
  gmyno.children.create name: 'Gnetales', common_name: 'Gnetum', note: 'Incl. Ephedra and Welwitschia'
  gmyno.children.create name: 'Pinales', common_name: 'Pine', note: 'Conifers: Incl. cedar, celery-pine, cypress, fir, juniper, larch, pine, redwood, spruce, and yew'
 
angio = seed_plants.children.create name: 'Angiosperms', common_name: 'Flowering Plants', note: 'Flowering Plants'

  anita = angio.children.create name: 'Anita', common_name: 'Most basal angiosperms', note: 'ANITA stands for Amborella, Nymphaeales and Illiciales, Trimeniaceae-Austrobaileya'
    anita.children.create name: "Amborellales", common_name: '', note: 'Amborella trichopoda is only  species'
    anita.children.create name: "Nymphaeales", common_name: '', note: 'water lily basal angiosperms'
    anita.children.create name: 'Austrobaileyales', common_name: '', note: 'woody trees, shrubs and lianas. Incl. spice star anise'
  
  angio.children.create name: 'Chloranthales', common_name: '', note: 'Chloranthus used as a tea; Sarcandra glabra is cultivated as an ornamental'

  magno = angio.children.create name: 'Magnoliids', common_name: '', note: ''
    magno.children.create name: 'Canellales', common_name: '', note: '2 families: Canellaceae and Winteraceae, 136 species of fragrant trees and shrubs'
    magno.children.create name: 'Piperales', common_name: '', note: 'Incl. lizard\'s Tail, birthwort, wild ginger, black pepper'
    magno.children.create name: 'Laurales', common_name: '', note: 'trees, shrubs, or woody vines. Lumber,  camphor, and essential oils derived from some Laurales species'
    magno.children.create name: 'Magnoliales', common_name: '', note: 'magnolia order Incl. woody shrubs, climbers, and trees'    

  mono = angio.children.create name: 'Monocots', common_name: '', note: ''
    mono.children.create name: 'Acorales', common_name: '', note: '2-4 species that resemble irises'
    mono.children.create name: 'Alismatales', common_name: '', note: 'Incl. water plantains, pondweed, flowering rush. Mostly tropical or aquatic'
    mono.children.create name: 'Petrosaviales', common_name: '', note: 'small order of rare leafless achlorophyllous,  plants found in dark  rainforests in Japan, Asia and Borneo'
    mono.children.create name: 'Dioscoreales', common_name: '', note: 'yam order, Incl. white yam, Chinese yams'
    mono.children.create name: 'Pandanales', common_name: '', note: 'Incl. screw pines and Panama hat plants. Twining herbs and lianas, as well as saprophytic herbs of  forest floor\' rainforests and coastal tropics'
    mono.children.create name: 'Liliales', common_name: '', note: 'lily order of largely perennial herbs and climbers'
    mono.children.create name: 'Asparagales', common_name: '', note: 'Incl.  orchids. onion, garlic, asparagus, vanilla, saffron'

    comme = mono.children.create name: 'Commelinids', common_name: 'Commelinids', note: ''
      comme.children.create name: 'Arecales', common_name: '', note: 'Single family, Arecaceae (also known as Palmae)'
      comme.children.create name: 'Poales', common_name: '', note: 'Incl.  grass family (Poaceae), cattails and sedges'
      comme.children.create name: 'Commelinales', common_name: '', note: 'Spiderwort and pickerelweed; mostly tropical and subtropical herbs'
      comme.children.create name: 'Zingiberales', common_name: '', note: 'Incl. bananas, plantains, manila hemp, and ginger'

  dicot = angio.children.create name: 'Eudicots', common_name: '', note: ''
      dicot.children.create name: 'Ceratophyllales', common_name: '', note: 'Hornwort  family (Ceratophyllaceae) with one  genus (Ceratophyllum)  10 species'
      dicot.children.create name: 'Ranunculales', common_name: '', note: 'buttercup order Incl. wild buttercups, marsh marigolds, chocolate vine, opium poppy, bleeding hearts'
      dicot.children.create name: 'Sabiales', common_name: '', note: 'Incl. single family (Sabiaceae), considered by some  as  member of Proteales'
      dicot.children.create name: 'Proteales', common_name: '', note: 'protea order peripheral eudicots. Incl. silver tree, Australian honeysuckles, silky oak, macadamia, American Lotus'
      dicot.children.create name: 'Trochodendrales', common_name: '', note: 'incl. wheel tree;  two extant genera, of south east Asia'
      dicot.children.create name: 'Buxales', common_name: '', note: 'evergreen shrubs or trees,  some herbaceous perennials'

      core = dicot.children.create name: 'Core eudicots', common_name: '', note: ''
        core.children.create name: 'Gunnerales', common_name: '', note: 'contains 2 families and 2 genera: Gunnera (Giant Rhubarb -family Gunneraceae) and Myrothamnus (family Myrothamnaceae)'
        
        rosid = core.children.create name: 'Rosids', common_name: '', note: ''
          rosid.children.create name: 'Dilleniales', common_name: '', note: 'one family, Dilleniaceae. Western Peony'
          rosid.children.create name: 'Saxifragales', common_name: '', note: 'Incl. witch hazel,  peonies,  currants , gooseberries, and saxifrage'
          rosid.children.create name: 'Vitales', common_name: '', note: 'grape order; most member are vines or lianas'

          fab = rosid.children.create name: 'Fabids', common_name: '', note: ''
            fab.children.create name: 'Zygophyllales', common_name: '', note: 'creosote bush order largely tropical or temperate arid or saline regions; Incl. bean capers'
            fab.children.create name: 'Celastrales', common_name: '', note: 'Incl. bittersweet, trees, lianas, and herbs'
            fab.children.create name: 'Oxalidales', common_name: '', note: 'wood sorrel order  Incl. annuals, perennial herbs, lianas, shrubs, and trees'
            fab.children.create name: 'Malpighiales', common_name: '', note: 'Incl. willows, violets, passionflowers, crotons, mangroves, and coca.  Many  tropical and poorly known species,'
            fab.children.create name: 'Fabales', common_name: '', note: 'Incl.  legumes, peas, beans, soybeans, peanuts, alfalfa, clover. '
            fab.children.create name: 'Rosales', common_name: '', note: 'Incl. roses, strawberries, raspberries, apples,  plums, peaches, almonds, elms, figs, mulberries,  hops,  cannabis'
            fab.children.create name: 'Cucurbitales', common_name: '', note: 'Incl. squash, pumpkins, melons, and cucumbers'
            fab.children.create name: 'Fagales', common_name: '', note: 'beech order Incl. oaks, beeches, walnuts, hickories, and birches'

          mal = rosid.children.create name: 'Malvids', common_name: '', note: ''
            mal.children.create name: 'Geraniales', common_name: '', note: 'geranium order.  mainly herbs with some woody shrubs or small trees'
            mal.children.create name: 'Myrtales', common_name: '', note: ' myrtle order Incl. many trees (e.g. Eucalyptus), shrubs (e.g. myrtle)'
            mal.children.create name: 'Crossosomatales', common_name: '', note: 'rockflower order of woody shrubs or trees of the northern temperate region'
            mal.children.create name: 'Picramniales', common_name: '', note: 'Incl. tallow wood tree, bitter bushes, acetylenic FA'
            mal.children.create name: 'Sapindales', common_name: '', note: 'Incl. the Citrus genus'
            mal.children.create name: 'Huerteales', common_name: '', note: 'incl. shrubs or small trees found in most tropical or warm temperate regions; poorly known'
            mal.children.create name: 'Malvales', common_name: '', note: 'Hibiscus or mallow order, mostly of woody plants'
            mal.children.create name: 'Brassicales', common_name: '', note: 'Incl. rapeseed, nasturtium, cabbages, Arabidopsis'
        
        core.children.create name: 'Santalales', common_name: '', note: 'sandalwood order all are parasitic to some degree, Incl. mistletoes'
        core.children.create name: 'Berberidopsidales', common_name: '', note: 'Southern Hemisphere woody flowering plants'
        core.children.create name: 'Caryophyllales', common_name: '', note: 'Incl. cacti, carnations, amaranths, ice plants, beets'
            
        asterid = core.children.create name: 'Asterids', common_name: '', note: ''
          asterid.children.create name: 'Cornales', common_name: '', note: 'dogwood order with plants that are mostly woody'
          asterid.children.create name: 'Ericales', common_name: '', note: 'Incl.  tea, persimmon, blueberry, Brazil nut, and azalea'
          
          lam = asterid.children.create name: 'Lamiids', common_name: '', note: ''
            lam.children.create name: 'Garryales', common_name: '', note: 'Woody;  Garryaceae family are evergreen, whereas  Eucommiaceae are deciduous and produce latex'
            lam.children.create name: 'Gentianales', common_name: '', note: 'gentian order.  sources of ornamental plants and drugs'
            lam.children.create name: 'Solanales', common_name: '', note: 'potato order; Incl. tomato, tobacco, nightshades and morning glories'
            lam.children.create name: 'Lamiales', common_name: '', note: 'Incl. lavender, lilac, olive, jasmine,  ash tree, teak, snapdragon, sesame,   mint, basil, and rosemary'
            lam.children.create name: 'Boraginales', common_name: '', note: 'Incl. borage, forget-me-nots'
            
          camp = asterid.children.create name: 'Campanulids', common_name: '', note: ''
            camp.children.create name: 'Aquifoliales', common_name: '', note: 'Incl. holly family; temperate Asian shrubs; 4 species of Central American trees and shrubs'
            camp.children.create name: 'Asterales', common_name: '', note: 'Asteraceae (or Compositae) Incl. sunflowers and chicory'
            camp.children.create name: 'Escalloniales', common_name: '', note: 'Member of Asterids clade'
            camp.children.create name: 'Bruniales', common_name: '', note: 'Incl. heath-like shrubs of S. Africa;  trees and shrubs native to  Andes of S. America'
            camp.children.create name: 'Apiales', common_name: '', note: 'incl. carrots, celery, parsley, ivy'
            camp.children.create name: 'Paracryphiales', common_name: '', note: ' woody shrubs and trees native to Australia, southeast Asia, and New Caledonia'
            camp.children.create name: 'Dipsacales', common_name: '', note: 'teasel or honeysuckle order Incl. Viburnum , and Scabiosa  or pincushion flower'
            
mosses = root.children.create name: 'Lycophytes', common_name: '', note: ''
  mosses.children.create name: 'Lycopodiales', common_name: '', note: 'clubmosses'
ferns = root.children.create name: 'Monilophytes', common_name: '', note: ''
  ferns.children.create name: 'Polypodiales', common_name: '', note: 'polypod ferns'
  ferns.children.create name: 'Equisetales', common_name: '', note: 'Horsetail'