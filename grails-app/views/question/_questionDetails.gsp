
%{--<to:occurrencePropertiesTable title="General" section="" names="occurrence.recordedBy, event.eventDate" occurrence="${occurrence}" />--}%
%{--<to:occurrencePropertiesTable title="Location" section="location" names="locality, decimalLatitude, decimalLongitude" occurrence="${occurrence}" />--}%
%{--<to:occurrencePropertiesTable title="Identification" section="classification" names="scientificName" occurrence="${occurrence}" />--}%
%{--<to:occurrencePropertiesTable title="Remarks" section="occurrence" names="occurrenceRemarks" occurrence="${occurrence}" />--}%

<to:occurrenceProperty name="occurrence.recordedBy" title="Recorded by" occurrence="${occurrence}" />
<to:occurrenceProperty name="event.eventDate" title="Event date" occurrence="${occurrence}" />
<to:occurrenceProperty name="location.locality" title="Locality" occurrence="${occurrence}" />
<to:occurrenceProperty name="classification.scientificName" title="Scientific name" occurrence="${occurrence}" />
<to:occurrenceProperty name="classification.commonName" title="Common name" occurrence="${occurrence}" />
<to:occurrenceProperty name="occurrence.occurrenceRemarks" title="Occurrence remarks" occurrence="${occurrence}" />
