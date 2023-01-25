USE bookAndNewspaperPublisher;
GO

CREATE VIEW production.[newspapers] AS 
	SELECT
		PP.productID,
		PA.articleID,
		PP.title AS newspaperTitle,
		PA.title AS articleTitle,
		PP.spread AS magazinSpread,
		PA.spread AS articleSpread, 
		PP.plannedPublicationDate,
		PP.releaseDate,
		PP.retailPrice
	FROM production.products AS PP
	INNER JOIN production.articles AS PA
	ON PP.productID = PA.productID;