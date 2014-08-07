FROM seal/seal-base

MAINTAINER Seal Software

# Bootstrap Ansible
RUN apt-get -y update
RUN apt-get install -y python-yaml python-jinja2 git
RUN git clone http://github.com/ansible/ansible.git /tmp/ansible
WORKDIR /tmp/ansible
ENV PATH /tmp/ansible/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ANSIBLE_LIBRARY /tmp/ansible/library
ENV PYTHONPATH /tmp/ansible/lib:$PYTHON_PATH
ADD ansible /tmp/docker-ansible
WORKDIR /tmp/docker-ansible
RUN ./run-ansible.sh -c local

EXPOSE 22 3000
