from kafka import KafkaProducer
import random
import time
import ssl
import sys

# Define Kafka configurations
conf = {
    'bootstrap_servers': ["smuthukumaran-1.novalocal:9092","smuthukumaran-2.novalocal:9092","smuthukumaran-3.novalocal:9092"],
    'sasl_plain_username': 'usercc',
    'sasl_plain_password': 'MyUserPasswd2024'
}
context = ssl.create_default_context()
context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
context.verify_mode = ssl.CERT_REQUIRED
context.load_verify_locations("cert.crt")


# Initialize Kafka Producer
print('start producer')
producer = KafkaProducer(bootstrap_servers=conf['bootstrap_servers'],
                        sasl_mechanism="PLAIN",
                        ssl_context=context,
                        security_protocol='SASL_SSL',
                        sasl_plain_username=conf['sasl_plain_username'],
                        sasl_plain_password=conf['sasl_plain_password'])

def generate_message(id):
    message = {
        'id': id,
        'random_int': random.randint(1, 100),
        'timestamp': int(time.time())
    }
    return str(message).encode('utf-8')

def main():
    topic = sys.argv[1]
    total_messages = 100000

    for i in range(total_messages):
        message = generate_message(i)
        producer.send(topic, message)
        producer.flush()
    print(f"Producer finished. Last message id: {total_messages - 1}")
    
if __name__ == "__main__":
    main()