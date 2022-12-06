FROM python

WORKDIR /home/server

COPY . ./

RUN pip install -r requirements.txt --quiet

EXPOSE 5050

CMD [ "python3", "./hello.py" ]
