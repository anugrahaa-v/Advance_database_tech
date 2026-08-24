# Lab 8: Demonstration of Import, Export, Dump, and Restore Operations in MongoDB
# NOTE: This lab's code is MongoDB command-line utilities (mongoexport, mongoimport,
# mongodump, mongorestore) and mongosh shell commands, not SQL
# (extracted exactly as it appears in the manual).

# ============================
# Export the existing collection
# ============================
mongoexport --version

mongoexport --db ott_platform_db --collection content --out ott_content.json --jsonArray
# connected to: mongodb://localhost/
# exported 5 records

# ============================
# Import the Prepared Dataset
# ============================
mongoimport --db ott_platform_db --collection content --file ott_content.json --jsonArray --drop
# connected to: mongodb://localhost/
# dropping: ott_platform_db.content
# 5 document(s) imported successfully. 0 document(s) failed to import.

# Verify existing documents (sorted by content_id)
db.content.find({}, {content_id:1, title:1, _id:0}).sort({content_id:1})

# ============================
# Append new records (without --drop)
# ============================
mongoimport --db ott_platform_db --collection content --file ott_new_content.json --jsonArray
# connected to: mongodb://localhost/
# 5 document(s) imported successfully. 0 document(s) failed to import.

# Verify count and appended records
db.content.countDocuments()
db.content.find({}, {content_id:1, title:1, genre:1, type:1, _id:0}).sort({content_id:1})

# ============================
# Export the Updated content Collection
# ============================
mongoexport --db ott_platform_db --collection content --out ott_content_updated.json --jsonArray
# connected to: mongodb://localhost/
# exported 10 records

# ============================
# Backup the MongoDB Database using mongodump
# ============================
# NOTE: the manual's screenshot under this heading duplicates the mongoexport
# command/output shown above (appears to be a copy-paste error in the original
# document); reproduced here exactly as it appears in the manual.
mongoexport --db ott_platform_db --collection content --out ott_content_updated.json --jsonArray
# connected to: mongodb://localhost/
# exported 10 records

# ============================
# Delete Selected Documents
# ============================
db.content.find(
    { content_id: { $gte: 506, $lte: 510 } },
    { _id: 0, content_id: 1, title: 1, genre: 1, type: 1 }
)

db.content.deleteMany({
    content_id: { $gte: 506, $lte: 510 }
})
# {
#   acknowledged: true,
#   deletedCount: 5
# }

# Verify remaining documents
db.content.countDocuments()
db.content.find({}, { _id: 0, content_id: 1, title: 1 }).sort({ content_id: 1 })

# ============================
# Restore the deleted records using mongorestore
# ============================
mongorestore --db ott_platform_db --collection content --drop ott_backup\ott_platform_db\content.bson
# checking for collection data in 'ott_backup\ott_platform_db\content.bson'
# reading metadata for 'ott_platform_db.content' from 'ott_backup\ott_platform_db\content.metadata.json'
# dropping collection 'ott_platform_db.content' before restoring
# restoring 'ott_platform_db.content' from 'ott_backup\ott_platform_db\content.bson'
# finished restoring 'ott_platform_db.content' (10 documents, 0 failures)
# no indexes to restore for collection 'ott_platform_db.content'
# 10 document(s) restored successfully. 0 document(s) failed to restore.

# ============================
# Verify that the database and collection were restored successfully
# ============================
show dbs

use("ott_platform_db")
show collections

db.content.countDocuments()
db.content.findOne()

# ============================
# Create an Index on content_id
# ============================
db.content.createIndex({ content_id: 1 })
# content_id_1

# Verify the Index
db.content.getIndexes()
# [
#   { v: 2, key: { _id: 1 }, name: '_id_' },
#   { v: 2, key: { content_id: 1 }, name: 'content_id_1' }
# ]

# Verify index usage with explain
db.content.find({ content_id: 506 }).explain("executionStats")
# winningPlan stage: 'FETCH' -> inputStage stage: 'IXSCAN' using index 'content_id_1'
