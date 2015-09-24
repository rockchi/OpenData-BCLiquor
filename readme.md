#OpenData BC-- BC Liquor Store Product Analysis

Over the Spring 2015 semester at SFU, most of my work was qualitative sided. 
To polish and keep up with some of the data analysis skills I have learnt over the past semesters, I decided to take on a side-project just for fun!
I had always been interested learning about the nature of products from data. The public data on wine offered a great opportunitiy to do so on store-sold liquor in BC!
The idea of the project is to analyze the open data available and to gain a better understanding of different product features' effect on pricing.

#####The Data
The data was a .csv file provided by [OpenData BC]{https://www.opendatabc.ca/dataset/bc-liquor-store-product-price-list-current-prices}.

#####Findings
You will find the insights and findings in the folder summarized as a PDF file. The PDF was originally a PowerPoint file but later converted since PDF is more accessible for the public.

#####Analysis Tools
- Visualizations: Tableau
- Statistics and Text Mining: R

#####Other Comments
During the analysis, I had noticed that there are not many product features stored as seperate variables in the given data. 
Product Long Name was a text snippet containing Year, Wineyard, Brand and Grape variety. These variables adds a lot more granularity and interesting findings.
To extract these features, I had to use a bit of Text-Mining (package tm) and scripting to later data blend and visualize in Tableau.
In the PDF presentation, breakdown of Price to text-mined features only included Grape Variety. This was done so because it was the easier of the features to extract and likely to be mentioned across all wines. (Turns out this was not the case!)

If I had more time, the text-mining to Tableau script would be changed to a function. Furthermore, extracting information on Brand and Year would be even more interesting.