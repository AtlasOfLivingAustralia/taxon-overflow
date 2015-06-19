databaseChangeLog = {

    changeSet(author: "rui008 (generated)", id: "1434687229766-1") {
        createTable(tableName: "answer") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "answerPK")
            }

            column(name: "version", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "accepted", type: "boolean") {
                constraints(nullable: "false")
            }

            column(name: "darwin_core", type: "text")

            column(name: "date_accepted", type: "timestamp")

            column(name: "date_created", type: "timestamp") {
                constraints(nullable: "false")
            }

            column(name: "description", type: "varchar(255)")

            column(name: "question_id", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "user_id", type: "int8") {
                constraints(nullable: "false")
            }
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-2") {
        createTable(tableName: "comment") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "commentPK")
            }

            column(name: "version", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "comment", type: "varchar(2048)") {
                constraints(nullable: "false")
            }

            column(name: "date_created", type: "timestamp")

            column(name: "user_id", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "class", type: "varchar(255)") {
                constraints(nullable: "false")
            }

            column(name: "answer_id", type: "int8")

            column(name: "question_id", type: "int8")
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-3") {
        createTable(tableName: "question") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "questionPK")
            }

            column(name: "version", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "date_created", type: "timestamp")

            column(name: "occurrence_id", type: "varchar(255)") {
                constraints(nullable: "false")
            }

            column(name: "question_type", type: "varchar(255)") {
                constraints(nullable: "false")
            }

            column(name: "source_id", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "user_id", type: "int8") {
                constraints(nullable: "false")
            }
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-4") {
        createTable(tableName: "question_tag") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "question_tagPK")
            }

            column(name: "version", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "date_created", type: "timestamp")

            column(name: "question_id", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "tag", type: "varchar(255)") {
                constraints(nullable: "false")
            }
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-5") {
        createTable(tableName: "question_view") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "question_viewPK")
            }

            column(name: "version", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "date_created", type: "timestamp") {
                constraints(nullable: "false")
            }

            column(name: "question_id", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "user_id", type: "int8") {
                constraints(nullable: "false")
            }
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-6") {
        createTable(tableName: "source") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "sourcePK")
            }

            column(name: "version", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "name", type: "varchar(255)") {
                constraints(nullable: "false")
            }

            column(name: "ui_base_url", type: "varchar(255)") {
                constraints(nullable: "false")
            }

            column(name: "ws_base_url", type: "varchar(255)") {
                constraints(nullable: "false")
            }
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-7") {
        createTable(tableName: "taxonoverflow_user") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "taxonoverflowPK")
            }

            column(name: "ala_user_id", type: "varchar(255)") {
                constraints(nullable: "false")
            }

            column(name: "enable_notifications", type: "boolean")
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-8") {
        createTable(tableName: "taxonoverflow_user_followed_questions") {
            column(name: "question_id", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "user_id", type: "int8") {
                constraints(nullable: "false")
            }
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-9") {
        createTable(tableName: "taxonoverflow_user_tags") {
            column(name: "user_id", type: "int8")

            column(name: "tags_string", type: "varchar(255)")
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-10") {
        createTable(tableName: "vote") {
            column(name: "id", type: "int8") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "votePK")
            }

            column(name: "version", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "date_created", type: "timestamp")

            column(name: "date_updated", type: "timestamp")

            column(name: "user_id", type: "int8") {
                constraints(nullable: "false")
            }

            column(name: "vote_value", type: "int4") {
                constraints(nullable: "false")
            }

            column(name: "class", type: "varchar(255)") {
                constraints(nullable: "false")
            }

            column(name: "answer_id", type: "int8")

            column(name: "comment_id", type: "int8")
        }
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-11") {
        addPrimaryKey(columnNames: "user_id, question_id", tableName: "taxonoverflow_user_followed_questions")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-28") {
        createSequence(sequenceName: "hibernate_sequence")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-12") {
        addForeignKeyConstraint(baseColumnNames: "question_id", baseTableName: "answer", constraintName: "FK_eix9du6u2r4wxwu415wq8yb99", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "question", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-13") {
        addForeignKeyConstraint(baseColumnNames: "user_id", baseTableName: "answer", constraintName: "FK_ilrlwe1trc8dyqaius89vprop", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "taxonoverflow_user", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-14") {
        addForeignKeyConstraint(baseColumnNames: "answer_id", baseTableName: "comment", constraintName: "FK_sr56od3koverm1nbbyiccj13o", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "answer", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-15") {
        addForeignKeyConstraint(baseColumnNames: "question_id", baseTableName: "comment", constraintName: "FK_f5qm0pi388f83ewfamcya091e", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "question", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-16") {
        addForeignKeyConstraint(baseColumnNames: "user_id", baseTableName: "comment", constraintName: "FK_mxoojfj9tmy8088avf57mpm02", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "taxonoverflow_user", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-17") {
        addForeignKeyConstraint(baseColumnNames: "source_id", baseTableName: "question", constraintName: "FK_fjs84y3wpau2w7f35bix9napl", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "source", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-18") {
        addForeignKeyConstraint(baseColumnNames: "user_id", baseTableName: "question", constraintName: "FK_os8bn3xr2x2owjn69es4hcxgs", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "taxonoverflow_user", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-19") {
        addForeignKeyConstraint(baseColumnNames: "question_id", baseTableName: "question_tag", constraintName: "FK_nohinfm7r87x757nhj9sf4ef2", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "question", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-20") {
        addForeignKeyConstraint(baseColumnNames: "question_id", baseTableName: "question_view", constraintName: "FK_266v7cfgvibgf428gudvj1dw4", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "question", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-21") {
        addForeignKeyConstraint(baseColumnNames: "user_id", baseTableName: "question_view", constraintName: "FK_ekhx2fkbh6rc9nnd9uae05j45", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "taxonoverflow_user", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-22") {
        addForeignKeyConstraint(baseColumnNames: "question_id", baseTableName: "taxonoverflow_user_followed_questions", constraintName: "FK_efydp2spv3jr6ys8oo9ehtgms", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "question", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-23") {
        addForeignKeyConstraint(baseColumnNames: "user_id", baseTableName: "taxonoverflow_user_followed_questions", constraintName: "FK_6fwvv6vhbddbm248d0mn25d8y", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "taxonoverflow_user", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-24") {
        addForeignKeyConstraint(baseColumnNames: "user_id", baseTableName: "taxonoverflow_user_tags", constraintName: "FK_aju67jl9cymj6bh0vca82t250", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "taxonoverflow_user", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-25") {
        addForeignKeyConstraint(baseColumnNames: "answer_id", baseTableName: "vote", constraintName: "FK_292m086588ag7f44erei5y9iu", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "answer", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-26") {
        addForeignKeyConstraint(baseColumnNames: "comment_id", baseTableName: "vote", constraintName: "FK_cobf4xrxm8cfav3khly26csuu", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "comment", referencesUniqueColumn: "false")
    }

    changeSet(author: "rui008 (generated)", id: "1434687229766-27") {
        addForeignKeyConstraint(baseColumnNames: "user_id", baseTableName: "vote", constraintName: "FK_dx2u8pwxfq611f6nsatwu44p0", deferrable: "false", initiallyDeferred: "false", referencedColumnNames: "id", referencedTableName: "taxonoverflow_user", referencesUniqueColumn: "false")
    }
}
