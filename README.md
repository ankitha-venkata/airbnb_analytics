# Airbnb_analytics

## Goal of Our Project

Airbnb is a website where people can book vacation properties that are listed by different hosts based on availability, price, reviews, amenities, etc. The goal of this project is to develop quantitatively backed suggestions for Airbnb listers to help them increase their customer ratings and profit margins.

## Business Use Cases

There are two types of users who can benefit from the findings of this project.

1. New listers who are looking to put their properties on Airbnb
What price point should they use? Which factors should they prioritize to increase their asking price?

2. Existing listers who have already put their properties up on Airbnb:

Which factors should they prioritize to increase their customer ratings? Which factors should they prioritize to increase their asking price?

## Exploratory Analysis

For this presentation, we choose the Airbnb dataset from Opendatasoft. The original dataset contains information that was scraped off of the Airbnb website in 2017 and contains all of the data points displayed for each listing on the website.

The original dataset contained 494,954 observations with 70 attributes but for ease of computation, data pertaining only to the United States was selected for the project. This included 134, 544 observations and after data cleaning, was brought down to 130,814 observations with 44 variables that have been included in the dataset description inserted below.

For the first segment of our analysis, the target variable was a column that was created to categorize reviews into Good and Bad. For the second segment, the target variable was the price data in $USD.

## Data Pre-processing

The following steps were taken to clean the data to make data handling easier:

The amenities column was hot encoded and separated into 106 separate attributes and hence each amenity was encoded in a binary manner.
1972 observations were found to have a price of 0 or NULL and these rows were deleted.
1665 observations were found to have a NULL Zipcode and these rows were deleted.
Certain property types were found to be present amongst less than 20 observations and the corresponding observations for these were removed, deleting 93 observations.
Certain observations were NULL for a majority of the attributes, and they were deleted.
After the preprocessing, the dataset contained 130,814 observations with 151 attributes.

## Data Visualization

Visualizations were drawn on the data and the findings were in line with our initial intuition:


Fig 1. Price vs Room Type
As the property space became more shared, the price of the property decreased. This is in line with our intuition of the market where renting out an entire house tends to be more expensive than staying in a hostel.


Fig 2. Price vs Cancellation Policies
It was found that the average price for a listing increased as the strictness of the cancellation policy increased. This could be explained by the higher business impact of cancellations on listings with higher pricing, pushing higher-priced listings to enforce stricter cancellation policies.


Fig 3. Price vs Property Type
It was found that the average price for Castles and Timeshares was higher than the other property types while the range for Villas, Houses, and Condos was higher than the other property types. Hostels, Dorms, and Tents had the lowest mean prices with even their higher outliers falling at around $100. This is consistent with the Fig 1 finding where shared rooms had the lowest prices.


Fig 4. Price vs Accommodation Numbers
It was found that there was a uniform increment in the average price of the listing as the accommodation capacity increased. This finding is in line with the general business model of Hotels and Stays where the pricing is heavily dependent on the number of people that can stay at the property.


Fig 5. Number of Listings Per State

Fig 6. Average Price per state
It was observed that the highest average price for listings was in the State of Texas with a value of over $200. Amongst the other states, there was a similar range of $100-$200. We also recognize that we do not have data for the listings in certain states and this may lead to a lack of accurate predictions. Certain states like California and New York have more data points for a better study.

## Multiple Linear Regression Model to predict Price of a listing

Goal: To predict the price of a new listing as well as assess the effect that individual factors had on the price of a listing

Model chosen: With a numerical target variable (Price) and various predictors (Categorical and Numeric), a Multiple Linear regression was chosen. With the MLR model, coefficients for each of the predictors could be found to assess the effect that each of these predictors has on the final Price. It can also be used to predict the price for a new observation based on prior observations which would help new listers understand how to competitively price their listing — answering both aspects of the intended goal.

Target Variable: Price ($USD)

Predictors: Based on the visualizations mentioned above and the results of the random forest model for price, the predictors for the model were chosen to be those that were highly correlated with price. This involved: Zip code, Property Type, Room Type, Accommodates, Bathrooms, Bedrooms, Beds, Bed Type, and Amenities.

Method: The model was run with these predictors and an R-square value of 0.4569 was achieved and when tested on the validation data, an RMSE of 100.6401 was achieved. However, aiming for a significance level for the R-square value of 0.7, the model was retrained to improve the goodness of fit on the training data. To improve the model, observations that contained a zipcode that was shared with less than 50 other observations, were removed from the dataset. Next, due to the large variation in price data, the price data was normalized, and the log of the price was taken. Also, certain amenities with no correlation with the price were removed from the list of predictors. This led to an improved R-square value of 0.7208 and when tested with the validation data, led to an RMSE of 0.3491, both measures of performance showing a significant improvement.

Results: The model achieved an R-squared value of 0.7207 with an adjusted R-squared value of 0.7187 on the training data set. When run on the validation data set, the achieved output was:


Fig 7. Predicted Values vs Observed Values
When the predicted values were plotted versus the observed values, it was observed that most of the data points were lying near the line which means that the predicted values were close to the observed values in a linear manner. However, it was observed that there were certain points that did not fall close to the line, and hence goes to show that the model can be improved.

Business Insights: From this Model, the price can be found for new listings to assist the new Airbnb listers in their setup process. Also, based on the coefficients of the predictors in the regression model equation, factors that relatively affect the price higher were found which would be useful for both existing listers as well as new listers. The top 3 amenities and the price increase caused by incorporating these amenities into the listing were:

1. Tub with Shower bench: $7.17

2. Disabled Parking Spot: $3.55

3. Washer Dryer: $2.07

## Improvements

Newer Data — the data in this dataset is from 2017 and hence does not paint a picture of the current market
More Data — certain zip codes did not contain enough data to build a solid model off of
Bias — dataset contains more data about California and New York and will hence work better when predicting price information in these states
Ensemble learning — by building a Random forest or implementing algorithms like Gradient boosting, AdaBoost, etc we believe the accuracy of the model could be improved and we are working on this now
