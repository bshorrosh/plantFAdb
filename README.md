# PhyloFAdb - Phylogenetic Fatty Acid Database
http://phylofadb.bch.msu.edu

Plant based database of fatty acid compounds.

- This website is derived form the Seed Oil Fatty Acid (SOFA) database
- (http://sofa.mri.bund.de)
- Aitzetmüller, K., Matthäus, B., & Friedrich, H. (2003). A new database for seed oil fatty acids—the database SOFA. European Journal of Lipid Science and Technology, 105(2), 92-103
- Matthäus, B. (2012). The new database seed oil fatty acids (SOFA). Lipid Technology, 24(10), 230-234.


### Notes

> July 2015

---

Loaded SOFA literature listing. Skip authors and journal, will grab from TAB files (better formatting)
`thor pub:stub lib/data/literature.html`

- Created 14400 publications
- Created 8299 unique plants

---

Loaded SOFA molecules.
- set NLS_LANG 'AMERICAN_AMERICA.WE8ISO8859P1'
- convert greek characters to words (∆ to -delta-)
`thor mol:load lib/data/molecules.html`

673 total items:
- Parameter: 9
- FattyAcid: 587
- Sterol: 19
- Triacylglycerol: 49
- Tocopherol: 9
- Measures with a cas registry number: 255

---

Loaded SOFA TAB_xxx files. Grab publication by tab_id, update its author/journal. Create results for each measure. Log ambiguous measures to `ambiguous_measures.txt`. Log hidden tables to `tab_with_no_pub.txt`
`thor tab:load lib/sofa/`

* convert Triglyceride to Triacylglycerol
* convert greek characters to words

- 15601 total files
- 11992 files loaded without error
- 518 files partially loaded - a measure was not found
- 433 files loaded with an ambiguous measure (first match chosen)
- 1066 files with data but no matching pub (hidden in SOFA)
- 1592 files empty

- 97365 new data points loaded

---

exported all plant names for TNRS annotation
`out = File.open("plant_names.txt",'w')`
`Plant.find_each do |p|; out.puts "#{p.id},\"#{p.family} #{p.name}\"";end;nil`

http://tnrs.iplantcollaborative.org/TNRSapp.html
email: throwern@msu.edu
key: 3aba6da519414c04b0b8f211555b683b

---

Load TNRS names
`thor plant:load_tnrs lib/data/tnrs_results.txt`
_ 8299 total names processed
- 5428 Accepted names
- 1695 Synonym (used accepted name)
- 1 Orthographic variants
- 893 No opinion
- 282 No matches found (Illegitimate,Invalid,Rejected,No Matches Found)

---

Load lipidmaps IDs manually generated
`thor id:load_lipid_map lib/data/fatty-acid-lipidmaps-search-7-17.csv`
- 236 items processed
- 62 with ID
- 66 indefinite
- 107 not found
- 1 unknown

---

Load pubchem IDs based on cas lookup
`thor id:load_pubchem lib/data/cas-pubchem-kate-7-17.csv`
- 673 items processed
- 255 matches loaded
- 27 with cas had no pub

---

Get InchiKEY from CAS rn on Toxnet. Output found ids to `cas_found_inchi.txt`. not found ids to `cas_not_found_tox.txt`
- 155 FattyAcids with cas number and data points
- 96 Found on chemidplus toxnet database
  
Load lipidmaps data based on inchikey (structure, lm_ID, mass, formula, pubchem cid, systematic name, trivial name)
`thor mol:load_lm_data lib/data/LMSDFDownload6Apr15FinalAll.sdf lib/data/cas_found_inchi.txt`
- 96 inchi keys supplied
- 86 LM entries found and FA's updated
Not in LM: 
CUXYLFPMQMFGPL-MRZTUZPCSA-N :: delta - 18:3-delta-9c,11t,13t, pubchem - 93077 
WBHHMMIMDMUBKC-XFXZXTDPSA-N :: delta - 12-OH-18:1-delta-9c, pubchem - 643684 
SRELFLQJDOTNLJ-HNNXBMFYSA-N :: delta - 16:1cy, pubchem - 164601 
MTWGWIOCIREVRF-KRWDZBQOSA-N :: delta - 17-OH-18:4-delta-9a,11a,13a,15a, pubchem - 4204 
BDAGIHXWWSANSR-UHFFFAOYSA-N :: delta - 1:0, pubchem - 284 
XMVQWNRDPAAMJB-UHFFFAOYSA-N :: delta - 18:1cy, pubchem - 72853 
MUZYOAHCGSIXJH-UHFFFAOYSA-N :: delta - 9,10-cpa-17:0, pubchem - 160786 
AUBZNAUZNGCKAN-GWKQRERASA-N :: delta - S-9-OH-18:2-delta-10t,12a, pubchem - 20054934 
WLIGEPWCQYIUNZ-QGZVFWFLSA-N :: delta - 12-OH-18:1-delta-9a, pubchem - 5312857 
CGTVVCFTVVGYPL-UHFFFAOYSA-N :: delta - 6-OH-6-Me-9=O-28:0, pubchem - 194014 

> August 2015

---

Upload cas_numbers_to_sofa_Aug7.txt
`file = File.open("lib/data/cas_numbers_to_sofa_Aug7.txt",'r')`
`file.each do |line|; cas,mol = line.chomp.split("\t"); fa = FattyAcid.find_by(sofa_mol_id: mol); cas=cas.delete 8203.chr; fa.update_attribute(:cas_number, cas); end`
- 63 cas_numbers from sofa_ids
- Manually added PubChem CID -  5282782	M_435
- Now 218 FA have a CAS RN

parse extra cas data
`thor mol:parse_scifinder lib/data/PhyloFAdb\ fatty_acid\ with\ CAS\ number-Substance_08_21_2015.txt > lib/data/cas_number_substance_Aug21_test.txt`

---

Add name, other_names and formula to FA table
NLS_LANG='AMERICAN_AMERICA.WE8ISO8859P1'
export NLS_LANG

Upload cas_number_substance_Aug21.txt
`thor mol:add_cas_data lib/data/cas_number_substance_Aug21.txt`

- 218 entries
- 214 found in database
- 4 'no data' found
	CAS number: 15514-85-9
	CAS number: 13030-78-9
	CAS number: 4154-44-3
	CAS number: 503-07-1
- 210 FA annotated
- 4 MISSING CAS numbers!
  17711-08-9:: C18 H30 O2, 8,11,14-Octadecatrienoic acid, 278.43
  1188395-78-9:: C24 H46 O2, 19-Tetracosenoic acid, 366.62
  1426159-11-6:: C22 H42 O2, 17-Docosenoic acid, 338.57
  7329-42-2:: C20 H38 O2, 5-Eicosenoic acid, 310.51

---

Add new TNRS plant names. Reload this full file to get new plant names including family,genus,species
`thor plant:load_tnrs_full lib/data/plant_names/TNRS\ plant\ names\ Aug13.txt`

Total Plants: 8299
- Accepted: 5428
- Synonym: 1695
- No opinion: 893
- Invalid: 48
- Illegitimate: 127
- : 100
- Rejected name: 7
- Orth. var.: 1
- Accepted families: 7164
- Name matched families: 8199

---


> Sep 2015

Load extra plant names. 100 plants had no match in TNRS, needed manual lookup.
`thor plant:load_tnrs_resubmit lib/data/additional_plant_names/tnrs_resubmit.txt`
- Updated 99 plants

---

Upload updated cas rn data

`thor mol:add_new_cas lib/data/additional_cas_rn/new_cas_rn.txt`
 - Updated 88
 - No change 4

`thor mol:parse_scifinder lib> lib/data/cas_number_substance_Aug21_test.txt`

`thor mol:add_cas_data lib/data/additional_cas_rn/new_cas_substance.txt`
- 89 entries
- 81 found in database
-- NOT FOUND
	CAS	Formula	Name	Mass	Other Names
	80738-22-3	 C20 H30 O2	 5,11,14-Eicosatrien-8-ynoic acid, (Z,Z,Z)- (9CI)	 302.45	 8,9-Dehydroarachidonic acid
	638-53-9	 C13 H26 O2	 Tridecanoic acid	 214.34	 NSC 25955; NSC 69131; Tridecylic acid; n-Tridecanoic acid; n-Tridecoic acid
	13126-31-3	 C18 H34 O2	 7-Octadecenoic acid, (7Z)-	 282.46	 7-Octadecenoic acid, (Z)- (8CI); 7-Octadecenoic acid, cis- (7CI); (Z)-7-Octadecenoic acid; cis-7-Octadecenoic acid; Δ7-cis-Octadecenoic acid
	120193-28-4	 C18 H26 O2	 5-Octadecene-7,9-diynoic acid, (E)- (9CI)	 274.40	 
	33128-25-5	 C18 H28 O2	 7,9-Octadecadiynoic acid	 276.41	 
	136145-04-5	 C18 H30 O2	 11-Octadecen-9-ynoic acid, (Z)- (9CI)	 278.43	 cis-11-Octadecen-9-ynoic acid
	1646179-08-9	 C20 H28 O2	 13,17-Octadecadiene-9,11-diynoic acid, ethyl ester, (13Z)-	 300.44	 
	4706-60-9	 C16 H26 O2	 6,9,12-Hexadecatrienoic acid	 250.38	 


---

Build custom taxonomy tree from mobot apweb and link plant family to order

Add order name
`thor plant:load_mobot_order lib/data/taxonomy/family_to_order_clean.txt`

Add tree
Data from poster: http://www2.biologie.fu-berlin.de/sysbot/poster/poster1.pdf
and MOBOT AP tree: http://www.mobot.org/MOBOT/research/APweb/welcome.html
and web searches
`rake db:seed:single SEED=db/seed_tree.rb`

---



### License

Copyright © 2015 Michigan State University Board of Trustees

Licensed under the terms of the GPL 3.0 license. See LICENSE and COPYING for details

This work was funded by the DOE Great Lakes Bioenergy Research Center (DOE BER Office of Science DE-FC02-07ER64494).

