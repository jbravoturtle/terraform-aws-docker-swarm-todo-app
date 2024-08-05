#!/usr/bin/env python3
# Import necessary modules
import ssl  # Module for working with SSL/TLS connections
import socket  # Module for low-level network operations
from datetime import datetime  # Module for handling date and time

def get_ssl_expiry_date(hostname):
    """
    Retrieves the SSL/TLS certificate for the given hostname and extracts its expiration date.
    
    Args:
        hostname (str): The domain name of the website to check.
    
    Returns:
        datetime: The expiration date of the SSL/TLS certificate.
    """
    try:
        # Define the context for the SSL connection
        context = ssl.create_default_context()
        
        # Establish a connection to the server using a socket
        with socket.create_connection((hostname, 443), timeout=5) as sock:
            # Wrap the socket with SSL to initiate a secure connection
            with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                # Retrieve the SSL/TLS certificate from the server
                cert = ssock.getpeercert()
        
        # Extract the expiration date from the certificate
        expiry_date_str = cert.get('notAfter')
        
        # If the certificate does not have an expiration date, raise an error
        if not expiry_date_str:
            raise ValueError("Unable to retrieve expiration date from certificate.")
        
        # Convert the expiration date string to a datetime object
        expiry_date = datetime.strptime(expiry_date_str, "%b %d %H:%M:%S %Y %Z")
        
        return expiry_date  # Return the expiration date as a datetime object
    
    except ssl.SSLError as ssl_error:
        # Handle SSL-related errors, such as handshake failures
        raise ConnectionError(f"SSL error occurred: {ssl_error}")
    except socket.error as socket_error:
        # Handle network-related errors, such as connection timeouts
        raise ConnectionError(f"Network error occurred: {socket_error}")
    except Exception as general_error:
        # Handle any other exceptions that might occur
        raise RuntimeError(f"An error occurred: {general_error}")

def main():
    """
    Main function to prompt the user for a website and display the SSL/TLS certificate expiration date.
    """
    # Prompt the user to input a website URL (hostname)
    hostname = input("Enter the website URL (e.g., example.com): ").strip()

    # Check if a hostname was provided; if not, exit the function
    if not hostname:
        print("No hostname provided. Exiting.")
        return
    
    try:
        # Call the function to get the SSL/TLS certificate expiration date
        expiry_date = get_ssl_expiry_date(hostname)
        
        # Print the expiration date in a human-readable format
        print(f"The SSL/TLS certificate for {hostname} expires on: {expiry_date.strftime('%Y-%m-%d %H:%M:%S %Z')}")
    
    except ConnectionError as conn_error:
        # Handle connection-related errors and print a message
        print(f"Failed to connect to {hostname}: {conn_error}")
    except RuntimeError as runtime_error:
        # Handle runtime errors and print a message
        print(f"Failed to retrieve SSL certificate information: {runtime_error}")
    except Exception as unexpected_error:
        # Handle any unexpected errors and print a message
        print(f"An unexpected error occurred: {unexpected_error}")

# Entry point of the script; the main function will run only if this script is executed directly
if __name__ == "__main__":
    main()
