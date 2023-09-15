# pull official base image
FROM --platform=linux/amd64 python:3.11.5-alpine3.18

# set work directory
WORKDIR /app

# copy project
COPY . .

# install dependencies
RUN pip install -r requirements.txt

EXPOSE 80

CMD ["python" , "/app/manage.py" , "runserver", "0.0.0.0:80"]




