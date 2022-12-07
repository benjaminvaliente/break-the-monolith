FROM python

WORKDIR /home/server

COPY . ./

RUN pip install -r requirements.txt --quiet

EXPOSE 80

CMD [ "python3", "./user.py" ]