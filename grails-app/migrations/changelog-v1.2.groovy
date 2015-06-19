databaseChangeLog = {

    changeSet(author: "rui008 (generated)", id: "add-title-to-question") {
        addColumn(tableName: "question") {
            column(name: "title", type: "varchar(255)")
        }

        grailsChange {
            change {
                sql.execute("UPDATE question SET title = ''")
            }
            rollback {
            }
        }

        addNotNullConstraint(tableName: "question", columnName: "title")
    }


}
