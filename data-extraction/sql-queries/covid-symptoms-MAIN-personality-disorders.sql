--Just want the output, not the messages
SET NOCOUNT ON; 

--personality disorders

PRINT 'Year,PersonalityDisorders'
select YEAR(EntryDate), count(*) as PersonalityDisorders from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('E02y400','E21..00','E21..11','E210.00','E210.11','E211.00','E211000','E211100','E211200','E211299','E211300','E211z00','E212.00','E212000','E212100','E212200','E212z00','E213.00','E213.11','E214.00','E214.11','E214000','E214100','E214z00','E215.00','E215.11','E215.99','E215000','E215200','E215300','E215z00','E216.00','E217.00','E217.11','E21y.00','E21y000','E21y100','E21y200','E21y300','E21y400','E21y500','E21y600','E21y700','E21y711','E21yz00','E21z.00','E21z.11','Eu06.00','Eu06000','Eu06011','Eu21.17','Eu21.18','Eu34011','Eu34112','Eu6..00','Eu60.00','Eu60000','Eu60011','Eu60012','Eu60013','Eu60014','Eu60100','Eu60200','Eu60211','Eu60212','Eu60213','Eu60214','Eu60215','Eu60300','Eu60311','Eu60312','Eu60313','Eu60400','Eu60411','Eu60412','Eu60500','Eu60511','Eu60512','Eu60513','Eu60600','Eu60700','Eu60711','Eu60712','Eu60713','Eu60714','Eu60y00','Eu60y11','Eu60y12','Eu60y13','Eu60y14','Eu60y15','Eu60y16','Eu60z00','Eu60z11','Eu60z12','Eu61.00','Eu6y.00','Eu6yy00','Eu6z.00','Eu84511','Eu94211','','E02y4','E21..','E210.','E211.','E2110','E2111','E2112','E2113','E211z','E212.','E2120','E2121','E2122','E212z','E213.','E214.','E2140','E2141','E214z','E215.','E2150','E2152','E2153','E215z','E216.','E217.','E21y.','E21y0','E21y1','E21y2','E21y3','E21y4','E21y5','E21y6','E21y7','E21yz','E21z.','Eu06.','Eu060','Eu6..','Eu60.','Eu600','Eu601','Eu602','Eu603','Eu604','Eu605','Eu606','Eu607','Eu60y','Eu60z','Eu61.','Eu6y.','Eu6yy','Eu6z.')
	and EntryDate >= '2000-01-01'
	group by PatID, EntryDate
) sub 
group by YEAR(EntryDate)
order by YEAR(EntryDate);


