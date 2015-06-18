#!/usr/bin/perl 

# myschema.p - defines schema for mysql tables

## to add a new table:
##    1 create @newtable_schema
##    2 add it to /usr/local/bscit/bin/Utils/copy_msql_tables.p
##    3 make a $prettyname{newtable}


## pretty names
$prettyname{county} = "California Counties";
$prettyname{dam} = "California Dams";
$prettyname{dams} = "California Dams";
$prettyname{eme} = "Essig Museum of Entomology";
$prettyname{EME} = "Essig Museum of Entomology";
$prettyname{FISH} = "FishBase";
$prettyname{gnis} = "USGS GNIS";
$prettyname{ITIS} = "ITIS";
$prettyname{itrank} = "BNHM IT Projects";
$prettyname{photographer} = "Photographers";
$prettyname{streets} = "Bay Area Streets";

## these are used to construct the whereclause for all tables

@nontextfields = qw(CatalogNumberNumeric DayCollected DayCollected2 DayIdentified
		    DecimalLongitude DecimalLatitude elevation IndividualCount
		    lat long lng MinElevationMeters MaxElevationMeters MinDepthMeters MaxDepthMeters
		    MonthCollected MonthCollected2 MonthIdentified seq_num sequence_num TSN 
		    YearCollected YearCollected2 YearIdentified);

@datefields = qw(DateLastModified entry_date index_date observ_date photo_date);


@ap_photos = qw(seq_num id pub_date big_url small_url story_url caption);

@tablestats_schema = qw(name owner cols rows rowsize tbl_dbsp numindex ind_dbsp);


@continent_schema = ('seq_num','name','u_name');

@county_schema = qw(num code name);

@country_schema = ('seq_num','code','name','continent');

@state_schema = ('seq_num','code','name');


@biocode_schema = qw(
    seq_num
    DateFirstEntered
    EnteredBy
    DateLastModified
    ModifiedBy
    ModifyReason
    ProjectCode
    OrigInstitution
    Specimen_Num_Collector
    CatalogNumberNumeric
    AccessionNumber
    VerbatimCollectingLabel
    VerbatimIDLabel
    CollectingLabelNotes
    specimen_ElevationMeters
    specimen_MinDepthMeters
    specimen_MaxDepthMeters
    ScientificName
    ColloquialName
    Kingdom
    Phylum
    Subphylum
    Superclass
    Class
    Subclass
    Infraclass
    Superorder
    Ordr
    Suborder
    Infraorder
    Superfamily
    Family
    Subfamily
    Tribe
    Subtribe
    Genus
    Subgenus
    SpecificEpithet
    SubspecificEpithet
    ScientificNameAuthor
    MorphoSpecies_Match
    MorphoSpecies_Description
    LowestTaxon
    LowestTaxonLevel
    IdentifiedBy
    IdentifiedInstitution
    BasisOfID
    YearIdentified
    MonthIdentified
    DayIdentified
    PreviousID
    TypeStatus
    SexCaste
    LifeStage
    Parts
    Weight
    WeightUnits
    Length
    LengthUnits
    PreparationType
    preservative
    fixative
    relaxant
    IndividualCount
    specimen_Habitat
    specimen_MicroHabitat
    Associated_Taxon
    Cultivated
    association_type
    color
    VoucherCatalogNumber
    Voucher_URI
    RelatedCatalogItem
    PublicAccess
    Notes
    pic
    bnhm_id
    record_source
    dl_notes
    DNASequenceNo
    RecheckFlag
    HoldingInstitution
    Coll_EventID
    Taxon_Certainty
    Tissue
    namesoup
    LowestTaxon_Generated
    parent_record
    child_exists
    batch_id
    SubProject
    SubSubProject
);

# added 2010-02-25 for download of ALL collecting_event and specimen fields .. jg

@biocode_download_schema = qw(
    biocode_collecting_event.EventID
    biocode_collecting_event.seq_num
    biocode_collecting_event.OtherEventID
    biocode_collecting_event.ProjectCode
    biocode_collecting_event.HoldingInstitution
    biocode_collecting_event.DateFirstEntered
    biocode_collecting_event.EnteredBy
    biocode_collecting_event.DateLastModified
    biocode_collecting_event.ModifiedBy
    biocode_collecting_event.Collector
    biocode_collecting_event.Collector2
    biocode_collecting_event.Collector3
    biocode_collecting_event.Collector4
    biocode_collecting_event.Collector5
    biocode_collecting_event.Collector6
    biocode_collecting_event.Collector7
    biocode_collecting_event.Collector8
    biocode_collecting_event.Collector_List
    biocode_collecting_event.YearCollected
    biocode_collecting_event.MonthCollected
    biocode_collecting_event.DayCollected
    biocode_collecting_event.TimeofDay
    biocode_collecting_event.YearCollected2
    biocode_collecting_event.MonthCollected2
    biocode_collecting_event.DayCollected2
    biocode_collecting_event.TimeofDay2
    biocode_collecting_event.ContinentOcean
    biocode_collecting_event.IslandGroup
    biocode_collecting_event.Island
    biocode_collecting_event.Country
    biocode_collecting_event.StateProvince
    biocode_collecting_event.County
    biocode_collecting_event.Locality
    biocode_collecting_event.Loc_Num
    biocode_collecting_event.DecimalLongitude
    biocode_collecting_event.DecimalLatitude
    biocode_collecting_event.DecimalLongitude2
    biocode_collecting_event.DecimalLatitude2
    biocode_collecting_event.HorizontalDatum
    biocode_collecting_event.MaxErrorInMeters
    biocode_collecting_event.MinElevationMeters
    biocode_collecting_event.MaxElevationMeters
    biocode_collecting_event.MinDepthMeters
    biocode_collecting_event.MaxDepthMeters
    biocode_collecting_event.DepthOfBottomMeters
    biocode_collecting_event.DepthErrorMeters
    biocode_collecting_event.IndividualCount
    biocode_collecting_event.Habitat
    biocode_collecting_event.MicroHabitat
    biocode_collecting_event.Collection_Method
    biocode_collecting_event.Landowner
    biocode_collecting_event.Permit_Info
    biocode_collecting_event.Remarks
    biocode_collecting_event.OtherEventInst
    biocode_collecting_event.OtherEventID2
    biocode_collecting_event.TaxTeam
    biocode_collecting_event.VerbatimLongitude
    biocode_collecting_event.VerbatimLatitude
    biocode_collecting_event.VerbatimLongitude2
    biocode_collecting_event.VerbatimLatitude2
    biocode_collecting_event.Disposition
    biocode_collecting_event.TaxonNotes
    biocode_collecting_event.Coll_EventID_collector
    biocode_collecting_event.pic
    biocode_collecting_event.batch_id
    biocode.seq_num
    biocode.DateFirstEntered
    biocode.EnteredBy
    biocode.DateLastModified
    biocode.ModifiedBy
    biocode.ModifyReason
    biocode.ProjectCode
    biocode.OrigInstitution
    biocode.Specimen_Num_Collector
    biocode.CatalogNumberNumeric
    biocode.AccessionNumber
    biocode.VerbatimCollectingLabel
    biocode.VerbatimIDLabel
    biocode.CollectingLabelNotes
    biocode.specimen_ElevationMeters
    biocode.specimen_MinDepthMeters
    biocode.specimen_MaxDepthMeters
    biocode.ScientificName
    biocode.ColloquialName
    biocode.Kingdom
    biocode.Phylum
    biocode.Subphylum
    biocode.Superclass
    biocode.Class
    biocode.Subclass
    biocode.Infraclass
    biocode.Superorder
    biocode.Ordr
    biocode.Suborder
    biocode.Infraorder
    biocode.Superfamily
    biocode.Family
    biocode.Subfamily
    biocode.Tribe
    biocode.Subtribe
    biocode.Genus
    biocode.Subgenus
    biocode.SpecificEpithet
    biocode.SubspecificEpithet
    biocode.ScientificNameAuthor
    biocode.MorphoSpecies_Match
    biocode.MorphoSpecies_Description
    biocode.LowestTaxon
    biocode.LowestTaxonLevel
    biocode.IdentifiedBy
    biocode.IdentifiedInstitution
    biocode.BasisOfID
    biocode.YearIdentified
    biocode.MonthIdentified
    biocode.DayIdentified
    biocode.PreviousID
    biocode.TypeStatus
    biocode.SexCaste
    biocode.LifeStage
    biocode.Parts
    biocode.Weight
    biocode.WeightUnits
    biocode.Length
    biocode.LengthUnits
    biocode.PreparationType
    biocode.preservative
    biocode.fixative
    biocode.relaxant
    biocode.IndividualCount
    biocode.specimen_Habitat
    biocode.specimen_MicroHabitat
    biocode.Associated_Taxon
    biocode.Cultivated
    biocode.association_type
    biocode.color
    biocode.VoucherCatalogNumber
    biocode.Voucher_URI
    biocode.RelatedCatalogItem
    biocode.PublicAccess
    biocode.Notes
    biocode.pic
    biocode.bnhm_id
    biocode.record_source
    biocode.dl_notes
    biocode.DNASequenceNo
    biocode.RecheckFlag
    biocode.HoldingInstitution
    biocode.Coll_EventID
    biocode.Taxon_Certainty
    biocode.Tissue
    biocode.namesoup
    biocode.LowestTaxon_Generated
    biocode.parent_record
    biocode.child_exists
    biocode.batch_id
);



# added 4/27/2009 for detail page ... jg


@biocode_specimen_and_collevent_schema = qw(
    biocode.seq_num 
    biocode.DateFirstEntered 
    biocode.EnteredBy 
    biocode_collecting_event.Coll_EventID_collector 
    biocode.DateLastModified 
    biocode.ModifiedBy 
    biocode.ModifyReason 
    biocode.ProjectCode 
    biocode.OrigInstitution 
    biocode.Specimen_Num_Collector 
    biocode.CatalogNumberNumeric  
    biocode.AccessionNumber 
    biocode_collecting_event.Collector 
    biocode_collecting_event.Collector2 
    biocode_collecting_event.Collector3 
    biocode_collecting_event.Collector4 
    biocode_collecting_event.Collector5 
    biocode_collecting_event.Collector6 
    biocode_collecting_event.Collector7 
    biocode_collecting_event.Collector8 
    biocode_collecting_event.Collector_List 
    biocode_collecting_event.YearCollected 
    biocode_collecting_event.MonthCollected  
    biocode_collecting_event.DayCollected 
    biocode.VerbatimCollectingLabel 
    biocode.VerbatimIDLabel 
    biocode_collecting_event.YearCollected2 
    biocode_collecting_event.MonthCollected2 
    biocode_collecting_event.DayCollected2 
    biocode.CollectingLabelNotes 
    biocode_collecting_event.TimeofDay 
    biocode_collecting_event.TimeofDay2 
    biocode_collecting_event.ContinentOcean 
    biocode_collecting_event.IslandGroup   
    biocode_collecting_event.Island 
    biocode_collecting_event.Country 
    biocode_collecting_event.StateProvince 
    biocode_collecting_event.County 
    biocode_collecting_event.Locality 
    biocode_collecting_event.DecimalLongitude 
    biocode_collecting_event.DecimalLatitude 
    biocode_collecting_event.DecimalLongitude2 
    biocode_collecting_event.DecimalLatitude2 
    biocode_collecting_event.HorizontalDatum 
    biocode_collecting_event.VerbatimLongitude 
    biocode_collecting_event.VerbatimLatitude 
    biocode_collecting_event.VerbatimLongitude2 
    biocode_collecting_event.VerbatimLatitude2 
    biocode_collecting_event.MaxErrorInMeters 
    biocode_collecting_event.MinElevationMeters 
    biocode_collecting_event.MaxElevationMeters  
    biocode_collecting_event.MinDepthMeters 
    biocode_collecting_event.MaxDepthMeters 
    biocode_collecting_event.DepthOfBottomMeters 
    biocode_collecting_event.DepthErrorMeters 
    biocode.ScientificName 
    biocode.ColloquialName 
    biocode.Kingdom 
    biocode.Phylum 
    biocode.Subphylum 
    biocode.Superclass 
    biocode.Class 
    biocode.Subclass 
    biocode.Infraclass 
    biocode.Superorder 
    biocode.Ordr 
    biocode.Suborder 
    biocode.Infraorder 
    biocode.Superfamily 
    biocode.Family 
    biocode.Subfamily 
    biocode.Tribe 
    biocode.Subtribe 
    biocode.Genus 
    biocode.Subgenus 
    biocode.SpecificEpithet 
    biocode.SubspecificEpithet 
    biocode.ScientificNameAuthor 
    biocode.MorphoSpecies_Match 
    biocode.MorphoSpecies_Description 
    biocode.LowestTaxon   
    biocode.LowestTaxonLevel 
    biocode.IdentifiedBy 
    biocode.IdentifiedInstitution 
    biocode.BasisOfID 
    biocode.YearIdentified 
    biocode.MonthIdentified 
    biocode.DayIdentified 
    biocode.PreviousID 
    biocode.TypeStatus 
    biocode.SexCaste 
    biocode.LifeStage 
    biocode.Parts   
    biocode.Weight 
    biocode.WeightUnits 
    biocode.Length 
    biocode.LengthUnits 
    biocode.PreparationType 
    biocode.preservative 
    biocode.fixative 
    biocode.relaxant 
    biocode.IndividualCount 
    biocode.specimen_Habitat
    biocode_collecting_event.Habitat 
    biocode.specimen_MicroHabitat 
    biocode_collecting_event.MicroHabitat 
    biocode.Associated_Taxon
    biocode.Cultivated 
    biocode.association_type
    biocode.color
    biocode.VoucherCatalogNumber 
    biocode.Voucher_URI
    biocode.RelatedCatalogItem 
    biocode.PublicAccess 
    biocode.Notes 
    biocode.pic 
    biocode.bnhm_id 
    biocode.record_source 
    biocode.dl_notes   
    biocode.DNASequenceNo 
    biocode.RecheckFlag 
    biocode.HoldingInstitution 
    biocode.Coll_EventID 
    biocode_collecting_event.Collection_Method 
    biocode.Taxon_Certainty 
    biocode.Tissue 
    biocode.namesoup 
    biocode.LowestTaxon_Generated
    biocode.parent_record 
    biocode.child_exists 
    biocode.batch_id
    biocode.specimen_MinDepthMeters
    biocode.specimen_MaxDepthMeters
    biocode.specimen_ElevationMeters
    biocode.association_type
    biocode.color
    );



@biocode_simple_display_schema = qw(bnhm_id ScientificName ColloquialName Kingdom Phylum Class Ordr 
                Family Genus SpecificEpithet SubspecificEpithet Collector_List YearCollected 
                Locality County pic DecimalLongitude DecimalLatitude HorizontalDatum 
                MaxErrorInMeters PublicAccess Coll_EventID Specimen_Num_Collector
	        Coll_EventID_collector LowestTaxon Taxon_Certainty);

@biocode_simple_display_join_schema = qw(biocode.bnhm_id biocode.ScientificName biocode.ColloquialName biocode.Kingdom biocode.Phylum biocode.Class biocode.Ordr 
                biocode.Family biocode.Genus biocode.SpecificEpithet biocode.SubspecificEpithet biocode_collecting_event.Collector_List 
                biocode_collecting_event.YearCollected 
                biocode_collecting_event.Locality biocode_collecting_event.County biocode.pic 
                biocode_collecting_event.DecimalLongitude biocode_collecting_event.DecimalLatitude biocode_collecting_event.HorizontalDatum 
                biocode_collecting_event.MaxErrorInMeters biocode.PublicAccess biocode.Coll_EventID biocode.Specimen_Num_Collector
	        biocode_collecting_event.Coll_EventID_collector biocode.LowestTaxon biocode.Taxon_Certainty);

@biocode_species_display_schema = qw(Kingdom Phylum Class Subclass Ordr Suborder Family
                                     Subfamily Tribe Genus Subgenus SpecificEpithet 
                                     SubspecificEpithet ColloquialName);

@biocode_species_download_schema = qw(seq_num kingdom phylum class subclass ordr suborder superfamily family subfamily
                                     tribe subtribe genus subgenus species subspecies);



@biocode_titles_schema = qw(encode titleno authcit authbib authfull title sauthor
                        stitle pubno publ
                        edition translator city publisher yrpub volume subvol page pages remarks
                        inpages prepages figures plates tables maps pubsource source);



@biocode_people_schema = qw(seq_num name_full name_last name_rest name_short name_initials passwd email index_date entry_by notes collector submitter edit_species affiliation bio num_specimens primary_name secondary_names copyright);

@biocode_collecting_event_schema = qw(
    EventID
    seq_num
    OtherEventID
    ProjectCode
    HoldingInstitution
    DateFirstEntered
    EnteredBy
    DateLastModified
    ModifiedBy
    Collector
    Collector2
    Collector3
    Collector4
    Collector5
    Collector6
    Collector7
    Collector8
    Collector_List
    YearCollected
    MonthCollected
    DayCollected
    TimeofDay
    YearCollected2
    MonthCollected2
    DayCollected2
    TimeofDay2
    ContinentOcean
    IslandGroup
    Island
    Country
    StateProvince
    County
    Locality
    Loc_Num
    DecimalLongitude
    DecimalLatitude
    DecimalLongitude2
    DecimalLatitude2
    HorizontalDatum
    MaxErrorInMeters
    MinElevationMeters
    MaxElevationMeters
    MinDepthMeters
    MaxDepthMeters
    DepthOfBottomMeters
    DepthErrorMeters
    IndividualCount
    Habitat
    MicroHabitat
    Collection_Method
    Landowner
    Permit_Info
    Remarks
    OtherEventInst
    OtherEventID2
    TaxTeam
    VerbatimLongitude
    VerbatimLatitude
    VerbatimLongitude2
    VerbatimLatitude2
    Disposition
    TaxonNotes
    Coll_EventID_collector
    pic
    batch_id

);

## fields from biocode_collecting_event that update specimen records

@biocode_collevent2spec_schema = qw(EventID Collector Collector2 Collector3 Collector4 Collector5 Collector6 Collector7 Collector8 Collector_List YearCollected MonthCollected DayCollected TimeofDay YearCollected2 MonthCollected2 DayCollected2 TimeofDay2 ContinentOcean IslandGroup Island Country StateProvince County Locality DecimalLongitude DecimalLatitude DecimalLongitude2 DecimalLatitude2 HorizontalDatum MaxErrorInMeters MinElevationMeters MaxElevationMeters MinDepthMeters MaxDepthMeters DepthOfBottomMeters Habitat Collection_Method VerbatimLongitude VerbatimLatitude VerbatimLongitude2 VerbatimLatitude2 Coll_EventID_collector);

# added 9/20/2006 so that coll event fields won't be updated on specimen form

@biocode_collevent2spec_update_schema = qw(ContinentOcean IslandGroup Island Country StateProvince County Locality DecimalLongitude DecimalLatitude DecimalLongitude2 DecimalLatitude2 HorizontalDatum MaxErrorInMeters MinElevationMeters MaxElevationMeters Habitat Collection_Method VerbatimLongitude VerbatimLatitude VerbatimLongitude2 VerbatimLatitude2);



@biocode_collecting_event_bm_schema = qw(EventID ProjectCode HoldingInstitution Collector_List MonthCollected DayCollected YearCollected Locality Country IndividualCount DecimalLongitude DecimalLatitude HorizontalDatum MaxErrorInMeters);

@biocode_species_schema = qw(seq_num kingdom phylum subphylum superclass class subclass infraclass superorder ordr suborder infraorder superfamily family subfamily tribe subtribe genus subgenus species subspecies author year species_notes lter_num cabinet drawer quantity pinned alcohol slides papered disposition_notes type photo date_added edit_name_date checkflag source collection);


@biocode_tissue_schema = qw(seq_num bnhm_id tissue_num HoldingInstitution OtherCatalogNum DateFirstEntered DateLastModified year month day person_subsampling container preservative tissuetype format_name96 well_number96 molecular_id notes from_tissue tissue_barcode tissue_remaining batch_id);

@biocode_extract_schema = qw(seq_num bnhm_id extract_num HoldingInstitution OtherCatalogNum DateFirstEntered year month day person_extracting container method elution_buffer dilution format_name96 well_number96 molecular_id notes from_tissue_seq_num from_specimen from_extract extract_barcode extract_remaining DateLastModified );

@biocode_trace_schema = qw(seq_num bnhm_id trace_num from_extract GeneratingInstitution OtherCatalogNum entry_date year month day person_sequencing format_name96 well_number96 molecular_id forward_PCR_primer reverse_PCR_primer seq_primer trace_file target_locus phred_file notes);

@biocode_sequence_schema = qw(seq_num gen_locus trace_num1 trace_num2 trace_num3 trace_num4 trace_num5 contig_num seq_fasta GeneratingInstitution Generating_method OtherCatalogNum entry_date year month day person_sequencing molecular_id notes);

@biocode_primer_schema = qw(seq_num primer_name primer_seq target_locus target_group notes);

@biocode_tissue_display_schema = qw(bnhm_id tissue_num Specimen_Num_Collector HoldingInstitution year month day person_subsampling container preservative tissuetype format_name96 well_number96 batch_id Family ScientificName);

@biocode_detail_species_schema = qw(seq_num kingdom phylum subphylum superclass class subclass infraclass superorder ordr suborder infraorder superfamily family subfamily tribe subtribe genus subgenus species subspecies author year species_notes photo);


@biocode_container_schema = qw(seq_num container);

@biocode_preservative_schema = qw(seq_num preservative);

@biocode_tissuetype_schema = qw(seq_num tissuetype);

@biocode_relaxant_schema = qw(seq_num relaxant);

@biocode_photo_schema = qw(seq_num bnhm_id eventID photo_num entry_date year month day photographer captivity ready photo_info photog_notes orig_filename photo_type);  # added photo_type 2007-05-01

@biocode_download_mvz_schema = qw(
    biocode_collecting_event.EventID
    biocode_collecting_event.DateFirstEntered
    biocode_collecting_event.EnteredBy
    biocode_collecting_event.DateLastModified
    biocode_collecting_event.ModifiedBy
    biocode_collecting_event.Collector
    biocode_collecting_event.Collector2
    biocode_collecting_event.Collector3
    biocode_collecting_event.Collector4
    biocode_collecting_event.YearCollected
    biocode_collecting_event.MonthCollected
    biocode_collecting_event.DayCollected
    biocode_collecting_event.TimeofDay
    biocode_collecting_event.ContinentOcean
    biocode_collecting_event.IslandGroup
    biocode_collecting_event.Island
    biocode_collecting_event.Country
    biocode_collecting_event.Locality
    biocode_collecting_event.DecimalLongitude
    biocode_collecting_event.DecimalLatitude
    biocode_collecting_event.HorizontalDatum
    biocode_collecting_event.MaxErrorInMeters
    biocode_collecting_event.MinElevationMeters
    biocode_collecting_event.MaxElevationMeters
    biocode_collecting_event.IndividualCount
    biocode_collecting_event.Habitat
    biocode_collecting_event.MicroHabitat
    biocode_collecting_event.Collection_Method
    biocode_collecting_event.Remarks
    biocode_collecting_event.VerbatimLongitude
    biocode_collecting_event.VerbatimLatitude
    biocode_collecting_event.TaxonNotes
    biocode_collecting_event.Coll_EventID_collector
    biocode_collecting_event.pic
    biocode.seq_num
    biocode.DateFirstEntered
    biocode.EnteredBy
    biocode.DateLastModified
    biocode.ModifiedBy
    biocode.ModifyReason
    biocode.Specimen_Num_Collector
    biocode.CatalogNumberNumeric
    biocode.ScientificName
    biocode.Kingdom
    biocode.Phylum
    biocode.Class
    biocode.Ordr
    biocode.Family
    biocode.Genus
    biocode.SpecificEpithet
    biocode.IdentifiedBy
    biocode.BasisOfID
    biocode.YearIdentified
    biocode.MonthIdentified
    biocode.DayIdentified
    biocode.PreviousID
    biocode.TypeStatus
    biocode.SexCaste
    biocode.LifeStage
    biocode.Parts
    biocode.Weight
    biocode.WeightUnits
    biocode.Length
    biocode.LengthUnits
    biocode.PreparationType
    biocode.preservative
    biocode.fixative
    biocode.IndividualCount
    biocode.specimen_Habitat
    biocode.specimen_MicroHabitat
    biocode.Associated_Taxon
    biocode.Cultivated
    biocode.VoucherCatalogNumber
    biocode.Voucher_URI
    biocode.RelatedCatalogItem
    biocode.PublicAccess
    biocode.Notes
    biocode.pic
    biocode.bnhm_id
    biocode.Tissue
);

# mvz_download fields   March 2010, from Carla     (rewritten in biocode_download_mvz_schema above)
#
# EventID[ce] DateFirstEntered[ce]    EnteredBy[ce]   DateLastModified[ce]    ModifiedBy[ce]  Collector[ce]   Collector2[ce]  Collector3[ce]  YearCollected[ce]   MonthCollected[ce]  DayCollected[ce]    TimeofDay[ce]   ContinentOcean[ce]  IslandGroup[ce] Island[ce]  Country[ce] Locality[ce]    DecimalLongitude[ce]    DecimalLatitude[ce] HorizontalDatum[ce] MaxErrorInMeters[ce]    MinElevationMeters[ce]  MaxElevationMeters[ce]  IndividualCount[ce] Habitat[ce] MicroHabitat[ce]    Collection_Method[ce]   Remarks[ce] VerbatimLongitude[ce]   VerbatimLatitude[ce]    TaxonNotes[ce]  Coll_EventID_collector[ce]  pic[ce] seq_num DateFirstEntered    EnteredBy   DateLastModified    ModifiedBy  ModifyReason    Specimen_Num_Collector  CatalogNumberNumeric    ScientificName  Kingdom Phylum  Class   Ordr    Family  Genus   SpecificEpithet IdentifiedBy    BasisOfID   YearIdentified  MonthIdentified DayIdentified   PreviousID  TypeStatus  SexCaste    LifeStage   Parts   Weight  WeightUnits Length  LengthUnits PreparationType preservative    fixative    IndividualCount specimen_Habitat    specimen_MicroHabitat   Associated_Taxon    Cultivated  VoucherCatalogNumber    Voucher_URI RelatedCatalogItem  PublicAccess    Notes   pic bnhm_id Tissue


@biocode_download_excel_collecting_event_schema = qw(
    biocode_collecting_event.Coll_EventID_collector
    biocode_collecting_event.EnteredBy
    biocode_collecting_event.TaxTeam
    biocode_collecting_event.Country
    biocode_collecting_event.YearCollected
    biocode_collecting_event.MonthCollected
    biocode_collecting_event.DayCollected
    biocode_collecting_event.TimeofDay
    biocode_collecting_event.Collector
    biocode_collecting_event.Collector2
    biocode_collecting_event.Collector3
    biocode_collecting_event.Collector4
    biocode_collecting_event.Collector5
    biocode_collecting_event.Collector6
    biocode_collecting_event.Collector7
    biocode_collecting_event.Collector8
    biocode_collecting_event.YearCollected2
    biocode_collecting_event.MonthCollected2
    biocode_collecting_event.DayCollected2
    biocode_collecting_event.TimeofDay2
    biocode_collecting_event.ContinentOcean
    biocode_collecting_event.IslandGroup
    biocode_collecting_event.Island
    biocode_collecting_event.StateProvince
    biocode_collecting_event.County
    biocode_collecting_event.Locality
    biocode_collecting_event.DecimalLongitude
    biocode_collecting_event.DecimalLatitude
    biocode_collecting_event.DecimalLongitude2
    biocode_collecting_event.DecimalLatitude2
    biocode_collecting_event.HorizontalDatum
    biocode_collecting_event.MaxErrorInMeters
    biocode_collecting_event.VerbatimLongitude
    biocode_collecting_event.VerbatimLatitude
    biocode_collecting_event.VerbatimLongitude2
    biocode_collecting_event.VerbatimLatitude2
    biocode_collecting_event.MinElevationMeters
    biocode_collecting_event.MaxElevationMeters
    biocode_collecting_event.MinDepthMeters
    biocode_collecting_event.MaxDepthMeters
    biocode_collecting_event.DepthOfBottomMeters
    biocode_collecting_event.DepthErrorMeters
    biocode_collecting_event.IndividualCount
    biocode_collecting_event.Habitat
    biocode_collecting_event.MicroHabitat
    biocode_collecting_event.Collection_Method
    biocode_collecting_event.Landowner
    biocode_collecting_event.Permit_Info
    biocode_collecting_event.Remarks
    biocode_collecting_event.TaxonNotes
    biocode_collecting_event.pic
);




@biocode_download_excel_specimen_schema = qw(
    biocode_collecting_event.Coll_EventID_collector
    biocode.EnteredBy
    biocode.Specimen_Num_Collector
    biocode.Phylum
    biocode.HoldingInstitution
    biocode.ColloquialName
    biocode.MorphoSpecies_Description
    biocode.MorphoSpecies_Match
    biocode.Kingdom
    biocode.Phylum
    biocode.Subphylum
    biocode.Superclass
    biocode.Class
    biocode.Subclass
    biocode.Infraclass
    biocode.Superorder
    biocode.Ordr
    biocode.Suborder
    biocode.Infraorder
    biocode.Superfamily
    biocode.Family
    biocode.Subfamily
    biocode.Tribe
    biocode.Subtribe
    biocode.Genus
    biocode.Subgenus
    biocode.SpecificEpithet
    biocode.SubspecificEpithet
    biocode.LowestTaxon
    biocode.LowestTaxonLevel
    biocode.Taxon_Certainty
    biocode.IdentifiedBy
    biocode.IdentifiedInstitution
    biocode.BasisOfID
    biocode.YearIdentified
    biocode.MonthIdentified
    biocode.DayIdentified
    biocode.SexCaste
    biocode.LifeStage
    biocode.Parts
    biocode.Weight
    biocode.WeightUnits
    biocode.Length
    biocode.LengthUnits
    biocode.PreparationType
    biocode.preservative
    biocode.relaxant
    biocode.fixative
    biocode.IndividualCount
    biocode.specimen_Habitat
    biocode.specimen_MicroHabitat
    biocode.Associated_Taxon
    biocode.RelatedCatalogItem
    biocode.Association_Type
    biocode.Color
    biocode.Cultivated
    biocode.Notes
    biocode.pic
    biocode.specimen_MinDepthMeters
    biocode.specimen_MaxDepthMeters





);

@biocode_download_si_emu_schema = qw(
   biocode.CatalogNumberNumeric
   biocode.Phylum
   biocode.Class
   biocode.Ordr
   biocode.Family
   biocode.LowestTaxon
   biocode.Taxon_Certainty
   biocode.IndividualCount
   biocode.IdentifiedBy
   biocode.YearIdentified    
   biocode.BasisOfID
   biocode.preservative
   biocode.Associated_Taxon
   biocode.SexCaste
   biocode.notes
   biocode.Specimen_Num_Collector
   biocode.coll_eventid
   biocode_collecting_event.ContinentOcean
   biocode_collecting_event.Country
   biocode_collecting_event.StateProvince
   biocode_collecting_event.County
   biocode_collecting_event.Locality
   biocode_collecting_event.MicroHabitat
   biocode_collecting_event.DecimalLatitude
   biocode_collecting_event.DecimalLongitude
   biocode_collecting_event.Collector_List
   biocode_collecting_event.YearCollected
   biocode_collecting_event.TimeofDay
   biocode_collecting_event.MinDepthMeters 
   biocode_collecting_event.MinElevationMeters
   biocode_collecting_event.Coll_EventID_collector 
   biocode_collecting_event.ProjectCode
   biocode_collecting_event.Collection_Method
   biocode_collecting_event.Remarks 

);

# SI/EMU also needs:
#
#   biocode.concatenateMonthIdentified/ DayIdentified/YearIdentified    
#   biocode.preservative OR fixative OR PreparationType 
#   biocode_collecting_event.concatenate? Locality/Habitat
#   biocode_collecting_event.concatenate MonthCollected/DayCollected/YearCollected


#@img_schema = qw(seq_num genre disknum imgnum kwid index_date DateLastModified collectn
#                 photographer organization contact copyright license orient enlarge
#                 captivity location
#                 county other_county state other_state
#                 country continent
#                 taxon family ordr class phylum
#                 cname ph_taxon ph_cname synonyms namesoup tsn lifeform calrecnum
#                 plant_comm photo_date source_id_1 source_id_2 photo_info
#                 photog_notes dl_notes blobs id_confirm inhabitants
#                 url_id url_type taxon_source cap_loc date_prec submittedby
#                 keywords taxon2 specimen_no museum island island_group
#                 cname_source ready coll_year coll_month coll_day project
#                 lat lng HorizontalDatum GeorefSource Lat_Long_Determined_By Lat_Long_Determined_Date
#                 GeorefRemarks MaximumUncertaintyInMeters VerificationStatus
#                 subject orig_filename external_enlargement_uri external_highres_uri);

@img_schema = qw(seq_num genre disknum imgnum kwid guid index_date DateLastModified collectn
                 photographer organization contact copyright license orient enlarge
                 captivity location
                 county other_county state other_state
                 country continent
                 taxon family ordr class phylum
                 cname ph_taxon ph_cname synonyms namesoup tsn lifeform calrecnum
                 plant_comm photo_date source_id_1 source_id_2 photo_info
                 photog_notes dl_notes blobs id_confirm inhabitants
                 url_id url_type taxon_source cap_loc date_prec submittedby
                 keywords taxon2 specimen_no museum island island_group
                 cname_source ready coll_year coll_month coll_day project
                 lat lng HorizontalDatum GeorefSource Lat_Long_Determined_By Lat_Long_Determined_Date
                 GeorefRemarks MaximumUncertaintyInMeters VerificationStatus
                 subject orig_filename external_enlargement_uri external_highres_uri associatedMedia associatedKwids);




1; #return true 




