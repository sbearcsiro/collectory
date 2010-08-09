package au.org.ala.collectory
import groovy.sql.Sql
import javax.sql.DataSource
import groovy.sql.GroovyRowResult
import org.springframework.transaction.annotation.Transactional

class IdGeneratorService {

    static transactional = true
    javax.sql.DataSource dataSource

    public enum IdType {
        collection,
        institution,
        dataProvider,
        dataResource,
        dataHub

        public getIndex() {
            return ordinal() + 1
        }
    };

    @Transactional(propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    def getNextId(IdType type) {
        def sql = new Sql(dataSource)
        def id = type.getIndex()

        GroovyRowResult row = sql.firstRow("select next_id,prefix from sequence where id = ?",[id]) as GroovyRowResult

        long next = row.next_id
        String prefix = row.prefix

        sql.executeUpdate("update sequence set next_id = ? where id = ?",[next + 1,id])

        return prefix + next
    }

    DataSource getDataSource() {
        return dataSource
    }

    /* convenience methods */
    def getNextCollectionId() {
        getNextId(IdType.collection)
    }
    def getNextInstitutionId() {
        getNextId(IdType.institution)
    }
    def getNextDataProviderId() {
        getNextId(IdType.dataProvider)
    }
    def getNextDataResourceId() {
        getNextId(IdType.dataResource)
    }
    def getNextDataHubId() {
        getNextId(IdType.dataHub)
    }
}
