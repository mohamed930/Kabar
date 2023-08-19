
# Kaber app.

As a user, I want to be able to search for news and preview details of any of them.





## Deployment

To deploy this project run

```bash
  git clone https://github.com/mohamed930/Kaber.git
```

```bash
  pod install
```


## API Reference

#### Get all news

```http
  GET /everything
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `q`       | `string` | **Required**.              |
| `language`| `string` | your language.             |
| `sortBy`  | `string` | **by default "publishedAt"**.|
| `pageSize`| `Int`    | for number of articles     |
| `page`    | `Int`    | number of page             |
| `apiKey`  | `string` | **Required**. Your API key |


#### Search for article

```http
  GET /everything
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `q`       | `string` | **Required**.              |
| `sortBy`  | `string` | **by default publishedAt**.|
| `pageSize`| `Int`    | for number of articles     |
| `page`    | `Int`    | number of page             |
| `apiKey`  | `string` | **Required**. Your API key |



## Documentation

[Documentation](https://drive.google.com/file/d/1UekG00hirJrm6oJmGouYw6rJUqYF8oGV/view?usp=sharing)


## Features

- Light/dark mode toggle
- App support Arabic - English
- On tapping on an article inside news details, Open the article on safari.
- Offline caching
- search about you article support any language.

## Screenshots

news light mode Eng        |  news dark mode Ar
:-------------------------:|:-------------------------:
![Screenshot](https://i.postimg.cc/L5nK4786/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-07-35.png)  |  ![Screenshot](https://i.postimg.cc/2SqQdxVb/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-09-02.png)        


news light mode Ar         |  news dark mode Ar
:-------------------------:|:-------------------------:
![](https://i.postimg.cc/h411KrJT/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-08-46.png)   |  ![](https://i.postimg.cc/2SqQdxVb/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-09-02.png)


news details light mode Eng |  news details dark mode Eng
:-------------------------: |:-------------------------:
![](https://i.postimg.cc/JhTcb4Lx/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-25-47.png)    |  ![](https://i.postimg.cc/DwvXBk5M/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-25-59.png)

news details light mode Ar |  news details dark mode Eng
:-------------------------:|:-------------------------:
![](https://i.postimg.cc/xTtrNMZb/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-24-37.png)   |  ![](https://i.postimg.cc/XJJB3wtc/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-24-05.png)


search suggestion light mode Eng |  search suggestion light mode Ara
:-------------------------:|:-------------------------:
![](https://i.postimg.cc/3rqSs1z1/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-34-24.png)    |  ![](https://i.postimg.cc/CKJJmsjj/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-34-13.png)

search suggestion light mode Ar |  search suggestion light mode Ar
:-------------------------:|:-------------------------:
![](https://i.postimg.cc/PxWDSXG0/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-34-47.png)   |  ![](https://i.postimg.cc/mkdtnhmp/Simulator-Screenshot-i-Phone-14-Pro-2023-08-19-at-13-35-02.png)



## Optimizations

I started doing app to analysis the app rquirement in the PDF and write user story in the board and sub task this user story in App Todoist

Examble from this board:

 ![](https://i.postimg.cc/C1tcyCm9/Screenshot-2023-08-19-at-1-50-39-PM.png)

  ![](https://i.postimg.cc/8z1B0nTj/Screenshot-2023-08-19-at-1-50-43-PM.png)


## UI Reference

I used this Figma file to make UI Friendly and have nice UX.

https://www.figma.com/file/57KrrsiHiweQnjAJX2OR8j/News-App-UI-Kit-(Community)?type=design&node-id=943-5984&mode=design&t=M8iSke0QBYV4LsAQ-0

![Logo](https://i.postimg.cc/Y2RgFPqq/Kaber.png)


## 🚀 About Me
I'm a mohamed Ali Ibrahim iOS Devloper,
this my email for contact mo.ali12477@gmail.com

