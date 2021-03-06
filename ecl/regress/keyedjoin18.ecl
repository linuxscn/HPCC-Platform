/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

#option ('targetClusterType', 'roxie');

mainRecord :=
        RECORD
integer8            sequence;
string20            forename;
string20            surname;
string20            alias;
unsigned8           filepos{virtual(fileposition)};
        END;

mainTable := dataset('~keyed.d00',mainRecord,THOR);

sequenceRecord := RECORD
        mainTable.sequence;
        mainTable.surname;
        mainTable.alias;
        mainTable.filepos;
    END;

nameKey := INDEX(mainTable, { surname, forename, filepos }, 'name.idx');
sequenceKey := INDEX(mainTable, sequenceRecord, 'sequence.idx');


peopleRecord := RECORD
integer8        id;
string20        addr;
            END;

//peopleDataset := DATASET([{3000,'London'}], peopleRecord);
peopleDataset := DATASET([{3000,'London'},{3500,'Miami'},{30,'Houndslow'}], peopleRecord);


output(join(peopleDataset, sequenceKey, left.id=right.sequence));                   // should have an implicit limit
output(join(peopleDataset, sequenceKey, left.id=right.sequence, atmost(100)));      // no implicit limit
output(join(peopleDataset, sequenceKey, left.id=right.sequence, limit(100)));       // no implicit limit
output(join(peopleDataset, sequenceKey, left.id=right.sequence, keep(100)));        // no implicit limit
output(join(peopleDataset, sequenceKey, keyed(left.id=right.sequence) and right.surname != '', keep(100)));     // implicit limit - since post filter
