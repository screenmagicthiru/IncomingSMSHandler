FROM ubuntu

#update the system and download the python
RUN apt-get update -y && \
    apt-get install -y python3-pip  && \
    apt-get install -y python3-venv && \
    apt-get install -y git

#install dependencies packages
RUN apt-get install -y libmysqlclient-dev && \
    apt-get install -y mariadb-server mariadb-client

# clone
RUN git clone https://github.com/screenmagicthiru/test-incominghandler.git

# create vertual env
RUN mkdir -p /home/virt/incoming_handler3/
RUN python3 -m venv /home/virt/incoming_handler3
RUN . /home/virt/incoming_handler3/bin/activate

# install requirement.txt
COPY ./requirements.txt /home/virt/incoming_handler3/requirements.txt
WORKDIR /home/virt/incoming_handler3/
RUN pip install -r requirements.txt


#Create logs
RUN mkdir -p /home/usher/logs/IncomingSMSHandler/ && \
    mkdir -p /extra-01/logs/IncomingSMSHandler/

#supervisor install and configure.
RUN apt-get install supervisor -y
COPY ./incomingsms_handler.conf  /etc/supervisor/conf.d/incomingsms_handler.conf

# restart supervisord
#CMD ["/usr/bin/supervisord"]

# update and restart supervisorctl
RUN supervisorctl
RUN update incoming_sms_handler
RUN status incoming_sms_handler
