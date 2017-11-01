FROM microsoft/dotnet:2-sdk

WORKDIR /opt/ombi

# Install node 8.x and npm 5.x
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Add sln and csproj files
COPY src/Ombi.sln /opt/ombi/
COPY src/*/*.csproj /opt/ombi/

# Put csproj files in their own folder as docker flattens the directory structure when doing fuzzy adds
RUN for file in ./*.csproj; do mkdir "${file%.*}" && mv "$file" "${file%.*}"; done;

# Restore nuget packages
RUN dotnet restore

# Add package.json and install dependencies
COPY src/Ombi/package*.json /opt/ombi/Ombi/
RUN cd Ombi/ && \
    npm install

# Copy the rest of the src
COPY src/ /opt/ombi/
