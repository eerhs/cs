from kafka import KafkaConsumer
import ssl
import sys

# Define Kafka configurations
conf = {
    'bootstrap_servers': ["smuthukumaran-1.novalocal:9092","smuthukumaran-2.novalocal:9092","smuthukumaran-3.novalocal:9092"],
    'sasl_plain_username': 'usercc',
    'sasl_plain_password': 'MyUserPasswd2024',
    'consumer_id': 'consumer_id'
}
context = ssl.create_default_context()
context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
context.verify_mode = ssl.CERT_REQUIRED
context.load_verify_locations("cert.crt")

print('start consumer')
consumer = KafkaConsumer(bootstrap_servers=conf['bootstrap_servers'],
                        group_id=conf['consumer_id'],
                        sasl_mechanism="PLAIN",
                        ssl_context=context,
                        security_protocol='SASL_SSL',
                        auto_offset_reset='earliest',
                        consumer_timeout_ms = 15000,
                        sasl_plain_username=conf['sasl_plain_username'],
                        sasl_plain_password=conf['sasl_plain_password'])

def consume_messages(topic):
    consumer.subscribe([topic])
    total_messages = 0
    total_sum = 0

    for message in consumer:
        print(message)
        total_messages += 1
        #total_sum += message.value['random_int']

    print(f"Consumer finished. Messages read: {total_messages}, Sum of random_int: {total_sum}")

def main():
    topic = sys.argv[1]
    consume_messages(topic)

if __name__ == "__main__":
    main()